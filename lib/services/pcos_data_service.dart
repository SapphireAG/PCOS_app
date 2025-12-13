import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pcos_entry.dart';
import 'hash_id.dart';

class PcosDataService {
  static Future<void> uploadEntry({
    required double age,
    required double weight,
    required double cycle,
    required List<int> bin,
    required double probability,
  }) async {
    final hashedUser = await getHashedUserId();

    final entry = PcosEntry(
      age: age,
      weight: weight,
      cycleLength: cycle,
      skinDarkening: bin[0],
      hairGrowth: bin[1],
      weightGain: bin[2],
      irregularCycle: bin[3],
      fastFood: bin[4],
      pimples: bin[5],
      hairLoss: bin[6],
      predictionProb: probability,
      hashedUser: hashedUser,
    );

    await FirebaseFirestore.instance
        .collection("pcos_dataset")
        .add(entry.toJson());
  }
}
