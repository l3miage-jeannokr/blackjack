import 'package:blackjack/Models/player.dart';
import 'package:flutter/material.dart';
import '../Services/JoueurService.dart';
import 'game.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final JoueurService joueurService = JoueurService();
  final TextEditingController _nameController = TextEditingController();
  
  // Valeur par défaut pour les jetons au départ
  double _startingCoins = 100.0;

  @override
  void initState() {
    super.initState();
    // On récupère le nom existant au démarrage
    _nameController.text = joueurService.getPlayer()?.name ?? "";
  }

  void _sauvegarderEtJouer() {
    if (_nameController.text.isNotEmpty) {
      // On utilise _startingCoins.toInt() pour le score initial
      joueurService.savePlayer(Player(_nameController.text, _startingCoins.toInt(), false));
      
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const Game()),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un nom")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F522E),
      appBar: AppBar(
        title: const Text("BlackJack",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F522E),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Partie Gauche : Saisie du nom et bouton Commencer
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "QUI JOUE ?",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 22),
                        decoration: const InputDecoration(
                          hintText: "Entrez votre nom",
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _sauvegarderEtJouer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      child: const Text("Play"),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Partie Droite : Barre verticale pour les jetons
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              border: const Border(left: BorderSide(color: Colors.white12)),
            ),
            child: Column(
              children: [
                const Icon(Icons.monetization_on, color: Colors.yellow, size: 30),
                const SizedBox(height: 10),
                Text(
                  "${_startingCoins.toInt()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("COINS", style: TextStyle(color: Colors.white70, fontSize: 10)),
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      value: _startingCoins,
                      min: 50,
                      max: 1000,
                      divisions: 19, // Par paliers de 50
                      activeColor: Colors.yellow[700],
                      inactiveColor: Colors.white24,
                      onChanged: (double value) {
                        setState(() {
                          _startingCoins = value;
                        });
                      },
                    ),
                  ),
                ),
                const Text("MIN: 50", style: TextStyle(color: Colors.white38, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
