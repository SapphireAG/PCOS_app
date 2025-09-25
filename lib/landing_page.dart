// import 'package:flutter/material.dart';
// import 'package:pcos_app/gradient_background.dart';
// import "package:pcos_app/symptoms_binary.dart";
// class LandingPage extends StatelessWidget {
//   const LandingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GradientBackground(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Center(
//           child:Column(
//             mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, 
//             children: [
//                  Text(
//      "PCOS",
//       textAlign: TextAlign.center,
//       style: const TextStyle(
//        color: Colors.white70,
//        fontSize: 20,
//         ),),
//               SizedBox(height: 10,),
//               ElevatedButton.icon(label:Text("What is PCOS? ", style: TextStyle(color: Colors.red, fontSize: 15),), onPressed: (){}, icon:Icon(Icons.question_answer,) , style: OutlinedButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.deepPurple)),
//               SizedBox(height: 10,),
//               ElevatedButton.icon(label:Text("Check The PCOS risk ", style: TextStyle(color: Colors.red, fontSize: 15),), onPressed: (){
//                 Navigator.pushNamed(context, "/symptoms_binary");
//               }, icon:Icon(Icons.question_answer,) , style:ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.deepPurple)),
//               SizedBox(height: 10,),
//               ElevatedButton.icon(label:Text("How the App Works ", style: TextStyle(color: Colors.red, fontSize: 15),), onPressed: (){}, icon:Icon(Icons.question_answer,) , style: OutlinedButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.deepPurple)),
//               SizedBox(height: 10,),
//               ElevatedButton.icon(label:Text("Previous Predictions", style: TextStyle(color: Colors.red, fontSize: 15),), onPressed: (){}, icon:Icon(Icons.question_answer,) , style: OutlinedButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.deepPurple)),
//               ],
//               )
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:pcos_app/gradient_background.dart';

class AppColors {
  // Primary pill (indigo) — high contrast on your gradient
  static const primary = Color(0xFF4338CA);
  static const primaryHover = Color(0xFF3730A3);

  // Glass/white pills
  static const nearBlack = Color(0xFF0B1220);
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "PCOS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // 1) What is PCOS?  (glass pill)
                PillButton.glass(
                  text: "What is PCOS?",
                  icon: Icons.menu_book_rounded,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),

                // 2) Check risk  (primary pill)
                PillButton.primary(
                  text: "Check the PCOS risk",
                  icon: Icons.health_and_safety_rounded,
                  onPressed: () {
                    Navigator.pushNamed(context, "/symptoms_binary");
                  },
                ),
                const SizedBox(height: 10),

                // 3) How the App Works  (glass pill)
                PillButton.glass(
                  text: "How the App Works",
                  icon: Icons.info_outline_rounded,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),

                // 4) Previous Predictions  (glass pill)
                PillButton.glass(
                  text: "Previous Predictions",
                  icon: Icons.history_rounded,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _PillVariant { primary, glass }

class PillButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final _PillVariant variant;

  const PillButton._({
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.variant,
    super.key,
  });

  factory PillButton.primary({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) =>
      PillButton._(
        text: text,
        icon: icon,
        onPressed: onPressed,
        variant: _PillVariant.primary,
      );

  factory PillButton.glass({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) =>
      PillButton._(
        text: text,
        icon: icon,
        onPressed: onPressed,
        variant: _PillVariant.glass,
      );

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = switch (variant) {
      _PillVariant.primary => ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white, // applies to icon + label
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const StadiumBorder(),
          elevation: 6,
          minimumSize: const Size(240, 48),
        ).merge(ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.pressed)
                ? AppColors.primaryHover
                : Colors.white.withValues(alpha:.06),
          ),
        )),
      _PillVariant.glass => ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.nearBlack,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha:.25),
          minimumSize: const Size(240, 48),
        ),
    };

    return ElevatedButton.icon(
      style: style,
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      // don’t set Text color manually—let foregroundColor control it
      label: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
