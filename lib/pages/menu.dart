import 'package:blackjack/models/player.dart';
import 'package:flutter/material.dart';
import '../services/joueur_service.dart';
import '../models/pop_up_msg.dart';
import 'game.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final JoueurService joueurService = JoueurService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  double _startingCoins = 100.0;

  @override
  void initState() {
    super.initState();
    _nameController.text = joueurService.getPlayer()?.name ?? "Pseudo";
    _passwordController.text = "";
  }

  void _creerCompte() {
    if (_nameController.text.isNotEmpty && _passwordController.text.isNotEmpty ) {
      joueurService.savePlayer(Player(_nameController.text, _startingCoins.toInt(), false, _passwordController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Compte créé avec succès !"),
            backgroundColor: Colors.white24,
            closeIconColor: Colors.yellowAccent,
            duration: const Duration(seconds: 2),
            showCloseIcon: true,
            padding: EdgeInsets.zero,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(PopUpMsg.name.message),
            backgroundColor: Colors.white24,
            closeIconColor: Colors.yellowAccent,
            duration: const Duration(seconds: 2),
            showCloseIcon: true,
            padding: EdgeInsets.zero,
        ),
      );
    }
  }

  void _sauvegarderEtJouer() {
    if (_nameController.text.isNotEmpty && _passwordController.text.isNotEmpty ) {
      if(joueurService.authentification(_nameController.text, _passwordController.text)){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Game()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(PopUpMsg.passwordInvalid.message),
                backgroundColor: Colors.white24,
                closeIconColor: Colors.yellowAccent,
                duration: const Duration(seconds: 2),
                showCloseIcon: true,
                padding: EdgeInsets.zero,
            ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(PopUpMsg.name.message),
            backgroundColor: Colors.white24,
            closeIconColor: Colors.yellowAccent,
            duration: const Duration(seconds: 2),
            showCloseIcon: true,
            padding: EdgeInsets.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0F522E),
      appBar: AppBar(
        title:  Text(PopUpMsg.bj.message,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F522E),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                   Text(
                     PopUpMsg.turn.message,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                      decoration:  InputDecoration(
                        hintText: PopUpMsg.name.message,
                        hintStyle: const TextStyle(color: Colors.white54),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                      decoration:  InputDecoration(
                        hintText: PopUpMsg.password.message,
                        hintStyle: const TextStyle(color: Colors.white54),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _creerCompte,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Créer Compte"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _sauvegarderEtJouer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        child: Text(PopUpMsg.play.message),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom / 2),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 80,
              margin: EdgeInsets.only(left: 40.0, right: MediaQuery.of(context).viewPadding.right),
              decoration: const BoxDecoration(
                color: Colors.black26,
                border: Border(left: BorderSide(color: Colors.white12)),
              ),
              child: SingleChildScrollView(
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
                    Text(PopUpMsg.coins.message, style: const TextStyle(color: Colors.white70, fontSize: 15)),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 100,
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
                    Text(PopUpMsg.min.message, style: const TextStyle(color: Colors.white38, fontSize: 15)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
