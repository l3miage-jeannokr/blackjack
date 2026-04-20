import 'package:blackjack/Models/card.dart';

class Player {
  String name = '';
  List<Card> hand = [];
  int bet = 0;
  int score = 0;
  int coins = 0;
  bool isDealer;

  Player(this.name, this.coins, this.isDealer);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'coins': coins,
      'isDealer': isDealer,
    };
  }

  Player.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        score = json['score'] ?? 0,
        coins = json['coins'] ?? 0,
        isDealer = json['isDealer'] ?? false;
}
