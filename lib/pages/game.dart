import 'package:blackjack/models/deck52.dart';
import '../models/card.dart';
import '../models/player.dart';

class Game {
  Deck52 deck = Deck52();
  List<Player> players = [Player("Player1", 100, false)];
  Player dealer = Player("Dealer",0,true);

  void turn(){
    for(Player player in players) {
      hit(player);

    }
    hit(dealer);
    results();
  }

  void decision(){

  }

  void bet(){

  }

  Card hit(Player player){
    return deck.cards[0];
  }

  void results() {

  }
}