import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:onnxruntime/onnxruntime.dart';
import 'package:flutter/material.dart';
class PcosStack {
  late final OrtSession _nn, _rf, _lr, _xgb, _meta;
  bool _ready = false;
  bool get isReady => _ready;
  PcosStack._();
  static final PcosStack instance = PcosStack._();
  Future<OrtSession> _load(String assetPath) async {
    final bytes = (await rootBundle.load(assetPath)).buffer.asUint8List();
    final opts = OrtSessionOptions();            // default CPU EP is fine
    return OrtSession.fromBuffer(bytes, opts);
  }

Future<void> init() async {
    try {
      final nn   = await _load('assets/models/nn_ir9Opt13.onnx');
      final rf   = await _load('assets/models/rf_ir9Opt13.onnx');
      final lr   = await _load('assets/models/lr_ir9Opt13.onnx');
      final xgb  = await _load('assets/models/xgb_ir9Opt13.onnx');
      final meta = await _load('assets/models/meta_ir9Opt13.onnx');

      // assign only after all succeeded
      _nn = nn; _rf = rf; _lr = lr; _xgb = xgb; _meta = meta;
      _ready = true;
    } catch (e, st) {
      debugPrint('PcosStack.init failed: $e\n$st');
      rethrow; // so your FutureBuilder shows error state
    }
  }
 Future<void> ensureInitialized() => init();
  void dispose() {
    _nn.release(); _rf.release(); _lr.release(); _xgb.release(); _meta.release();
  }

  double _probFromOutputs(List<Object?> outs) {
  // Prefer probabilities if two outputs (labels, probabilities)
  final out = outs.length == 2 ? outs[1] : outs[0];

  // 1) ZipMap case: Map<dynamic, dynamic> => values may be double or List<double>
  if (out is Map) {
    final dynamic v = out[1] ?? out['1'] ?? out.values.first;
    if (v is List) return (v.first as num).toDouble();
    return (v as num).toDouble();
  }

  // 2) Tensor case from onnxruntime_flutter
  if (out is OrtValueTensor) {
    final v = out.value; // can be Float32List, List<double>, or List<List<double>>
    // Float32List
    if (v is Float32List) {
      return v.length >= 2 ? v[1] : v[0];
    }
    // Plain list(s)
    if (v is List) {
      // flatten one level: [[p0,p1]] -> [p0,p1] ; [p0,p1] -> [p0,p1] ; [p] -> [p]
      final flat = v.expand((e) => e is List ? e : [e]).toList();
      final num prob1 = (flat.length >= 2 ? flat[1] : flat.first) as num;
      return prob1.toDouble();
    }
    throw Exception('Unexpected tensor value type: ${v.runtimeType}');
  }

  // 3) Some providers return Lists directly (rare)
  if (out is List) {
    final flat = out.expand((e) => e is List ? e : [e]).toList();
    final num prob1 = (flat.length >= 2 ? flat[1] : flat.first) as num;
    return prob1.toDouble();
  }

  throw Exception('Unexpected ONNX output type: ${out.runtimeType}');
}



  Future<double> _runBase(OrtSession s, String inputName, Float32List x) async {
    final input = OrtValueTensor.createTensorWithDataList(x, [1, x.length]);
    final outs = await s.runAsync(OrtRunOptions(), {inputName: input});
    if (outs != null) {
  debugPrint(
    outs.map((o) => o?.runtimeType.toString()).toList().toString()
  );
} else {
  debugPrint("outs is null");
}

    input.release();
    final p = _probFromOutputs(outs!);
    for (final o in outs) { o?.release(); }
    return p;
  }

  Future<double> predict(Float32List xFull) async {
    // input names must match your exported models:
    if (!_ready) throw StateError('PcosStack not initialized. Call init() first.');
    final pNN  = await _runBase(_nn,  'features', xFull);
    final pRF  = await _runBase(_rf,  'input',    xFull);
    final pLR  = await _runBase(_lr,  'input',    xFull);
    final pXGB = await _runBase(_xgb, 'input',    xFull);

    // meta stack
    final metaIn = OrtValueTensor.createTensorWithDataList(
      Float32List.fromList([pNN, pRF, pLR, pXGB]),
      [1, 4],
    );
    final outs = await _meta.runAsync(OrtRunOptions(), {'stack_input': metaIn});
    metaIn.release();
    final p = _probFromOutputs(outs!);
    for (final o in outs) { o?.release(); }
    return p; // P(class=1)
  }
}
