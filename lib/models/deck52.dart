import 'card.dart';
import 'suit.dart';
import 'rank.dart';

class Deck52 {
  List<Card> cards = [];
  Deck52() {
    List<int> values = [0,1,2,3,4,5,6,7,8,9,10,10,10,10];
    for (Suit suit in Suit.values) {
      for (Rank rank in Rank.values) {
        cards.add(Card(rank, suit, values[rank.index]));
      }
    }
  }

  void shuffle() {
    cards.shuffle();
  }
}