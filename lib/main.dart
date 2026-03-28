import 'package:blackjack/pages/Menu.dart';
import 'package:blackjack/Services/JoueurService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  // Nécessaire pour initialiser les plugins comme local_storage avant runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation du JoueurService (qui initialise local_storage)
  await JoueurService().init();

  // Forcer l'orientation paysage
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blackjack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Menu(),
    );
  }
}