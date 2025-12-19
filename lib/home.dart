import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> hasAcceptedPolicy() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('accepted_policy') ?? false;
}

Future<void> setAcceptedPolicy() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('accepted_policy', true);
}


Future<void> clearPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

class AppColors {
  // gradient
  static const bg1 = Color(0xFF2A84F2);
  static const bg2 = Color(0xFF9C27B0);
  static const bg3 = Color(0xFFEF423C);

  // button options
  static const indigo     = Color(0xFF4338CA); // primary (recommended)
  static const indigoHover= Color(0xFF3730A3);
  static const nearBlack  = Color(0xFF0B1220); // alt dark pill
}
String privacyPolicy= '''
This Privacy Policy explains how your information is collected, used, stored, and protected when you use the PCOS Prediction Software installed on your handheld device (“Software”, “we”, “us”, or “our”). By using this Software, you agree to the practices described in this document.
1. Information We Collect
1.1 Self-Reported Health Inputs
Symptoms (e.g., hair growth, acne, cycle irregularity)
Behavioural indicators (e.g., lifestyle patterns)
Cycle-related information (e.g., cycle length, flow days)
Demographic details (e.g., age, weight)
1.2 Device Information
Device type and model
Operating system version
Software version
1.3 No Sensitive Personal Identifiers
We do not collect or store your name, address, email, phone number, government-issued IDs, or GPS location.
2. How We Use Your Information
Generate PCOS risk predictions
Improve performance and model accuracy through anonymized data
Comply with legal obligations
3. Data Storage and Security
Data is stored locally on your device
No unauthorized sharing, selling, or renting of data
Industry-standard security protocols are applied
4. Data Retention
• Your data remains on your device until deleted by you• Aggregated anonymous statistics may be retained for research
5. Your Rights
Right to access, correct, or delete data
Right to withdraw consent by discontinuing use
6. Children's Privacy
This Software is intended for users 18 years and above. Minors may use it only under parental or guardian supervision.
7. Third-Party Services
This Software does not currently integrate with any third-party analytics, cloud services, or advertising systems. If this changes in future versions, the Privacy Policy will be updated accordingly.
8. Changes to This Privacy Policy
We may revise this policy periodically. Continued use of the Software after updates implies acceptance.
 
''';
String termsOfService='''
1. Acceptance of Terms
By installing, accessing, or using this PCOS Prediction Software on your handheld device, you agree to be bound by these Terms of Service and all applicable laws. If you do not agree, please do not use this software.
2. Purpose of the Software
This software provides risk indication for Polycystic Ovary Syndrome (PCOS) using self-reported information and machine-learning models.
The software does not provide a medical diagnosis.
All outputs are probabilistic predictions based on patterns learned from data and may not always be accurate.
This tool is intended solely for informational, educational, and awareness purposes.

3. No Medical Advice Disclaimer
This software is NOT a medical device.
The results must not be interpreted as medical advice, diagnosis, or treatment recommendations.
Users must consult a qualified healthcare professional for medical decisions.
Do not delay or avoid seeking medical care based on the output of this software.
4. User Responsibilities
By using this software, you agree that:
You will provide accurate and truthful information to the best of your knowledge.
You understand that incorrect or incomplete inputs may affect prediction accuracy.
You will not rely on the software for emergency situations or self-treatment.
5. Data Handling and Privacy
This software may collect inputs such as symptoms, age, cycle-related information, and behavioural indicators solely for generating predictions.
Personal information is handled according to the Privacy Policy, accessible here:[Insert Privacy Policy Link]
No data is shared with third parties without consent, unless required by law.
6. Intellectual Property Rights
All algorithms, user interface elements, design components, text, graphics, and underlying software architecture are the intellectual property of the developer/manufacturer.
Users may not copy, modify, reverse engineer, distribute, or exploit any part of the software without written permission.
7. Limitations of Liability
To the fullest extent permitted by law:
The developer/manufacturer is not liable for any direct, indirect, incidental, or consequential damages arising from use or inability to use the software.
The developer is not responsible for inaccurate results caused by incorrect user inputs, data limitations, or inherent model uncertainties.
The software is provided “as is” without warranties of any kind, express or implied.
8. Modification of Service
The developer/manufacturer reserves the right to:
Update, upgrade, or modify the software at any time.
Change these Terms of Service with reasonable notice.
Continued use after changes constitutes acceptance.
9. User Access and Security
You are responsible for maintaining the confidentiality of any login or authentication credentials.
Attempts to tamper with, hack, or disrupt the functioning of the software are strictly prohibited.
10. Age Restrictions
This software is intended for individuals 18 years and above.Users below 18 should use the device only under parent or guardian supervision.
11. Governing Law
These Terms are governed by the laws of India, without regard to conflict-of-law principles.
Any disputes shall fall under the jurisdiction of Tamil Nadu, India, unless otherwise required by law.

''';
class HomeWidget extends StatefulWidget{
  const HomeWidget({super.key});

  @override

    State<HomeWidget> createState()=> _HomeWidgetState();
  
}

class _HomeWidgetState extends State<HomeWidget>{
  Future<void> _showPoliciesFlow(BuildContext context) async {
  // 1. Terms of Service
  final termsAccepted = await showPoliciesBottomSheet(
    context: context,
    title: 'Terms of Service',
    text: termsOfService,
  );

  if (termsAccepted != true) return; // user dismissed or backed out

  // 2. Privacy Policy
  final privacyAccepted = await showPoliciesBottomSheet(
    context: context,
    title: 'Privacy Policy',
    text: privacyPolicy,
  );

  if (privacyAccepted == true) {
    await setAcceptedPolicy();
  }
}

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      clearPrefs();
      bool accepted = await hasAcceptedPolicy();
      if (!accepted) {
        _showPoliciesFlow(context);
      }
    });
  }

@override 
  Widget build(context){
    return Center(child: 
    Column(
      mainAxisAlignment:MainAxisAlignment.center,
      mainAxisSize:MainAxisSize.min,
      children: [
        Image.asset(
          'assets/healthcare.png',
          width: 100,
          color: const Color.fromARGB(149, 255, 255, 255),
        ),
        const SizedBox(height: 30),
        Text("Take Control of PCOS", 
        style: TextStyle(color: Colors.white,fontSize: 25
        ),
        ),
        const SizedBox(height:15),
        Text(
     "Empowering Early PCOS\ndetection",
      textAlign: TextAlign.center,
      style: const TextStyle(
       color: Colors.white70,
       fontSize: 15,
        ),
      ),
      const SizedBox(height:10),
        OutlinedButton.icon(onPressed: (){Navigator.pushNamed(context,
        '/landing_page');}, label: Text("Get Started", 
        style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        icon: Icon(Icons.play_arrow,color: Colors.white,),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.indigo,
          foregroundColor: Colors.white) 
          ),
        const SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: (){showPoliciesBottomSheet(context: context,
                                  title: 'Terms of Service',
                                  text: termsOfService,);}, child: Text("Terms of Service",style: TextStyle(color: Colors.white70),)),
            TextButton(onPressed: (){showPoliciesBottomSheet(    context: context,
    title: 'Privacy Policy',
    text: privacyPolicy,);}, child: Text("\tPrivacy Policy",style: TextStyle(color: Colors.white70),))
          ],
        )
        
      ],
      )
      );
  }
  
Future<bool?> showPoliciesBottomSheet({
  required BuildContext context,
  required String title,
  required String text,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // user agreed
                  },
                  child: const Text('I Agree'),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}



}