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
      decision(player);
    }
    hit(dealer);
  }

  void decision(Player player){
    if (player.score < 21) {
      // open popup for decision pass or hit
    }
  }

  void bet(){
    // TODO: it 2
  }

  Card hit(Player player){
    return deck.cards[0];
  }

  // check if on of the players has won and display winning screen
  bool results() {
    return false;
  }
  // manage the game
  void main(){
    bool gameStatus = false;
    players = [Player("Player1", 100, false)];
    deck = Deck52();
    deck.shuffle();
    while (!gameStatus) {
      //bet();
      turn();
      gameStatus = results();
    }
  }

}