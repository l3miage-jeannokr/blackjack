import 'dart:convert';
import 'package:blackjack/Models/player.dart';
import 'package:localstorage/localstorage.dart';

class JoueurService {
  static final JoueurService _JoueurService = JoueurService._internal();

  factory JoueurService() => _JoueurService;

  JoueurService._internal();

  init() async {
    await initLocalStorage();
  }

  savePlayer(Player player) {
    localStorage.setItem("player", jsonEncode(player.toJson()));
  }

  Player? getPlayer() {
    final playerJson = localStorage.getItem("player");
    return playerJson != null ? Player.fromJson(jsonDecode(playerJson)) : null;
  }

  clearPlayer() async {
    localStorage.removeItem("player");
  }
}
