import 'dart:convert';
import 'package:blackjack/models/player.dart';
import 'package:localstorage/localstorage.dart';

class JoueurService {
  static final JoueurService joueurService = JoueurService._internal();

  factory JoueurService() => joueurService;

  JoueurService._internal();

  Future<void> init() async {
    await initLocalStorage();
  }

  void savePlayer(Player player) {
    localStorage.setItem("player", jsonEncode(player.toJson()));
  }

  Player? getPlayer() {
    final playerJson = localStorage.getItem("player");
    return playerJson != null ? Player.fromJson(jsonDecode(playerJson)) : null;
  }

  bool authentification(String name, String password) {
    Player? player = getPlayer();
    if (player != null && player.name == name && player.password == password) {
      return true;
    }
    return false;
  }

  Future<void> clearPlayer() async {
    localStorage.removeItem("player");
  }
}
