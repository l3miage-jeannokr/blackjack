import 'package:blackjack/models/card.dart';

class Player {
  String name = '';
  List<Card> hand = [];
  int bet = 0;
  int score = 0;
  bool isDealer;

  Player(this.name,this.score, this.isDealer);
}