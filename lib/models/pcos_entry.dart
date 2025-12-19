import 'package:cloud_firestore/cloud_firestore.dart';
class PcosEntry {
  final double age;
  final double weight;
  final double cycleLength;

  final int skinDarkening;
  final int hairGrowth;
  final int weightGain;
  final int irregularCycle;
  final int fastFood;
  final int pimples;
  final int hairLoss;

  final double predictionProb;
  final String hashedUser;
  final String? priorDiagnosis;
  final String? agreeWithResult;

  PcosEntry({
    required this.age,
    required this.weight,
    required this.cycleLength,
    required this.skinDarkening,
    required this.hairGrowth,
    required this.weightGain,
    required this.irregularCycle,
    required this.fastFood,
    required this.pimples,
    required this.hairLoss,
    required this.predictionProb,
    required this.hashedUser,
    required this.priorDiagnosis,
    required this.agreeWithResult
  });

  Map<String, dynamic> toJson() {
    return {
      "age": age,
      "weight": weight,
      "cycle_length": cycleLength,

      "skin_darkening": skinDarkening,
      "hair_growth": hairGrowth,
      "weight_gain": weightGain,
      "irregularCycle": irregularCycle,
      "fast_food": fastFood,
      "pimples": pimples,
      "hair_loss": hairLoss,

      "prediction_prob": predictionProb,
      "hashed_user": hashedUser,
      "timestamp": FieldValue.serverTimestamp(),
      "consent": true,
      "agree_with_result": agreeWithResult,
      "prior_diagnosis": priorDiagnosis,
    };
  }
}
