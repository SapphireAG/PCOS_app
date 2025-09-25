import 'package:flutter/material.dart';
import 'package:pcos_app/gradient_background.dart';
import 'package:pcos_app/home.dart';
import 'package:pcos_app/landing_page.dart';
import 'package:pcos_app/symptoms_binary.dart';
import 'package:pcos_app/symptoms_discrete.dart';
import 'package:pcos_app/likelihood_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = PcosStack.instance.init(); // create once
  runApp(MyApp(initFuture: initFuture));
}

class MyApp extends StatelessWidget {
  final Future<void> initFuture;
  const MyApp({super.key, required this.initFuture});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/landing_page': (_) => const LandingPage(),
        '/symptoms_binary': (_) => const SymptomInputPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/symptoms_discrete') {
          return MaterialPageRoute(
            builder: (_) => SymptomsDiscrete(bin: settings.arguments as List<int>),
          );
        }
        return null;
      },
      home: FutureBuilder<void>(
        future: initFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snap.hasError) {
            return Scaffold(
              body: Center(child: Text('Model init failed: ${snap.error}')),
            );
          }
          return const GradientBackground(
            child: Scaffold(backgroundColor: Colors.transparent, body: HomeWidget()),
          );
        },
      ),
    );
  }
}

