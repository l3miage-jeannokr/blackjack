import 'package:blackjack/Models/player.dart';
import 'package:flutter/material.dart';
import '../Services/joueur_service.dart';
import '../Models/PopupMsg.dart';
import 'game.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final JoueurService joueurService = JoueurService();
  final TextEditingController _nameController = TextEditingController();
  
  double _startingCoins = 100.0;

  @override
  void initState() {
    super.initState();
    _nameController.text = joueurService.getPlayer()?.name ?? "";
  }

  void _sauvegarderEtJouer() {
    if (_nameController.text.isNotEmpty) {
      joueurService.savePlayer(Player(_nameController.text, _startingCoins.toInt(), false));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Game()),
       );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Popupmsg.name.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F522E),
      appBar: AppBar(
        title:  Text(Popupmsg.bj.message,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F522E),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Partie Gauche : Saisie du nom et bouton Commencer
          Center(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     Text(
                       Popupmsg.turn.message,
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
                        decoration:  InputDecoration(
                          hintText: Popupmsg.name.message,
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
                      child: Text(Popupmsg.play.message),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Partie Droite : Barre verticale pour les jetons
          Align(
            alignment: Alignment.centerRight,
              child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(),
                border: const Border(left: BorderSide(color: Colors.white12)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.euro, color: Colors.yellow, size: 40),
                  const SizedBox(height: 5),
                  Text(
                    "${_startingCoins.toInt()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(Popupmsg.coins.message, style: TextStyle(color: Colors.white70, fontSize: 15)),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        value: _startingCoins,
                        min: 50,
                        max: 1000,
                        divisions: 19,
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
                  const SizedBox(height: 10),
                  Text(Popupmsg.min.message, style: TextStyle(color: Colors.white38, fontSize: 15)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
