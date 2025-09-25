import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pcos_app/symptoms_binary.dart';
import 'package:pcos_app/likelihood_model.dart';
class SymptomsDiscrete extends StatefulWidget {
  final List<int> bin;
  const SymptomsDiscrete({super.key,required this.bin});
  @override
  State<SymptomsDiscrete> createState() => _SymptomsDiscreteState();
}
const contMean = <double>[
  59.63715341959335,
  31.430683918669132,
  4.9408502772643255,
];

const contStd = <double>[
  11.018089915702744,
  5.406002456869452,
  1.4906406771016456,
]; 

class _SymptomsDiscreteState extends State<SymptomsDiscrete> {
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _cycleController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _cycleController.dispose();
    super.dispose();
  }
  // StandardScaler stats from training (order: age, weight, cycle)

List<double> scaleContinuous(List<double> cont) => List.generate(3, (i) {
    final s = contStd[i] == 0 ? 1e-8 : contStd[i];
    return (cont[i] - contMean[i]) / s;
  });


Future<void> _getSymptomDiscrete() async {
  final age    = double.tryParse(_ageController.text.trim());
  final weight = double.tryParse(_weightController.text.trim());
  final cycle  = double.tryParse(_cycleController.text.trim());

  final messenger = ScaffoldMessenger.of(context); // capture before await

  if (age == null || weight == null || cycle == null) {
    messenger.showSnackBar(const SnackBar(content: Text('Please enter valid numbers.')));
    return;
  }

  final contScaled = scaleContinuous([weight, age, cycle]);

  if (!PcosStack.instance.isReady) {
    messenger.showSnackBar(const SnackBar(content: Text('Model is still loading…')));
    return;
  }

  final all  = <double>[...contScaled, ...widget.bin.map((b) => b.toDouble())];
  final xAll = Float32List.fromList(all);

  final prob = await PcosStack.instance.predict(xAll);

  if (!mounted) return; // <- important
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('PCOS Risk'),
      content: Text('Probability: ${prob.toStringAsFixed(3)}\n${prob >= 0.5 ? 'High risk' : 'Low risk'}'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Symptom Input')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LabeledField(
                label: 'Age',
                controller: _ageController,
                hint: 'Enter age',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Weight (kg)',
                controller: _weightController,
                hint: 'Enter weight',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Menstrual cycle length (days)',
                controller: _cycleController,
                hint: 'Cycle length in days',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 54),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _getSymptomDiscrete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4338CA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),

                  child: const Text('Check Risk',style: TextStyle(color: Colors.white,fontSize:15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _LabeledField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
