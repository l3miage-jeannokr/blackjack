import 'package:blackjack/Models/deck52.dart';
import 'package:blackjack/Models/card.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:blackjack/Models/player.dart';
import 'package:blackjack/Models/suit.dart' as suit_model;
import 'package:blackjack/Models/rank.dart' as rank_model;
import 'package:blackjack/Services/JoueurService.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final JoueurService joueurService = JoueurService();
  late Player player;
  late Player dealer;
  late Deck52 deck;
  bool isGameInProgress = false;
  bool showDealerHiddenCard = false;
  int currentBet = 10;

  @override
  void initState() {
    super.initState();
    _initGameData();
  }

  void _initGameData() {
    player = joueurService.getPlayer() ?? Player("Joueur", 100, false);
    dealer = Player("Croupier", 0, true);
    deck = Deck52();
    isGameInProgress = false;
    showDealerHiddenCard = false;
  }

  void _drawCard(Player p) {
    if (deck.cards.isNotEmpty) {
      Card drawnCard = deck.cards.removeAt(0);
      p.hand.add(drawnCard);
      p.score = _calculateScore(p.hand);
    }
  }

  void _startNewRound() {
    if (player.coins < currentBet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pas assez de jetons !")),
      );
      return;
    }

    setState(() {
      deck = Deck52();
      deck.cards.shuffle();
      player.hand = [];
      dealer.hand = [];
      player.bet = currentBet;
      player.coins -= currentBet;
      joueurService.savePlayer(player); // On sauvegarde la mise déduite immédiatement
      showDealerHiddenCard = false;
      isGameInProgress = true;

      _drawCard(player);
      _drawCard(player);
      _drawCard(dealer);
      _drawCard(dealer);

      if (player.score == 21) {
        _stand(); // Vérification immédiate du Blackjack
      }
    });
  }

  void _hit() {
    setState(() {
      _drawCard(player);
      if (player.score > 21) {
        isGameInProgress = false;
        showDealerHiddenCard = true;
        joueurService.savePlayer(player);
        _showResultDialog("Bust ! Vous avez dépassé 21.", isWin: false);
      }
    });
  }

  void _doubleDown() {
    if (player.coins < player.bet) return;
    setState(() {
      player.coins -= player.bet;
      player.bet *= 2;
      joueurService.savePlayer(player);
      _drawCard(player);
      if (player.score > 21) {
        isGameInProgress = false;
        showDealerHiddenCard = true;
        _showResultDialog("Bust ! Vous avez dépassé 21.", isWin: false);
      } else {
        _stand();
      }
    });
  }

  bool _isBlackjack(Player p) => p.hand.length == 2 && p.score == 21;

  void _stand() async {
    setState(() {
      isGameInProgress = false;
      showDealerHiddenCard = true;
    });

    if (player.score <= 21) {
      while (dealer.score < 17) {
        await Future.delayed(const Duration(milliseconds: 600));
        setState(() {
          _drawCard(dealer);
        });
      }
    }

    String message = "";
    bool isWin = false;
    bool playerBJ = _isBlackjack(player);
    bool dealerBJ = _isBlackjack(dealer);

    if (player.score > 21) {
      message = "Bust ! Vous avez perdu.";
    } else if (dealer.score > 21) {
      message = "Le croupier a sauté ! Vous gagnez.";
      player.coins += playerBJ ? (player.bet * 2.5).toInt() : (player.bet * 2);
      isWin = true;
    } else if (playerBJ && !dealerBJ) {
      message = "BLACKJACK !";
      player.coins += (player.bet * 2.5).toInt();
      isWin = true;
    } else if (dealerBJ && !playerBJ) {
      message = "Le croupier a un Blackjack. Perdu.";
    } else if (player.score > dealer.score) {
      message = "Gagné !";
      player.coins += player.bet * 2;
      isWin = true;
    } else if (player.score < dealer.score) {
      message = "Perdu... ${player.score} vs ${dealer.score}";
    } else {
      message = "Égalité (Push)";
      player.coins += player.bet;
    }

    joueurService.savePlayer(player);
    _showResultDialog(message, isWin: isWin);
  }

  int _calculateScore(List<Card> hand) {
    int score = 0;
    int aces = 0;
    for (var card in hand) {
      int val = card.value + 1;
      if (val > 10) val = 10;
      if (val == 1) {
        aces++;
        val = 11;
      }
      score += val;
    }
    while (score > 21 && aces > 0) {
      score -= 10;
      aces--;
    }
    return score;
  }

  void _showResultDialog(String message, {required bool isWin}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isWin ? "Félicitations !" : "Résultat"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initGameData();
              setState(() {});
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F522E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Banque: ${player.coins} €",
            style: const TextStyle(color: Colors.yellowAccent)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDealerSection(),
          const Text("VS",
              style: TextStyle(
                  color: Colors.white24,
                  fontSize: 40,
                  fontWeight: FontWeight.bold)),
          _buildPlayerSection(player),
          _buildActionPanel(),
        ],
      ),
    );
  }

  Widget _buildDealerSection() {
    return Column(
      children: [
        Text(dealer.name,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: List.generate(dealer.hand.length, (index) {
            if (index == 1 && !showDealerHiddenCard && isGameInProgress) {
              return _buildCardBack();
            }
            return _buildCard(dealer.hand[index]);
          }),
        ),
        const SizedBox(height: 5),
        Text(
            "Score: ${showDealerHiddenCard ? dealer.score : '?'}",
            style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildPlayerSection(Player p) {
    return Column(
      children: [
        Text(p.name,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: p.hand.map((card) => _buildCard(card)).toList(),
        ),
        const SizedBox(height: 5),
        Text("Score: ${p.score} | Mise: ${p.bet} €",
            style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildActionPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black26,
      child: isGameInProgress
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton("HIT", Colors.blue, _hit),
                _actionButton("DOUBLE", Colors.purple, _doubleDown),
                _actionButton("STAND", Colors.orange, _stand),
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("MISE: ", style: TextStyle(color: Colors.white)),
                    Slider(
                      value: currentBet.toDouble(),
                      min: 10,
                      max: player.coins >= 10 ? player.coins.toDouble() : 10,
                      divisions: player.coins > 10 ? (player.coins / 10).floor() : 1,
                      onChanged: (v) => setState(() => currentBet = v.toInt()),
                    ),
                    Text("${currentBet}€",
                        style: const TextStyle(color: Colors.yellowAccent)),
                  ],
                ),
                _actionButton(
                    "DISTRIBUER", Colors.yellow[800]!, _startNewRound),
              ],
            ),
    );
  }

  Widget _buildCard(Card card) {
    return Container(
      width: 60,
      height: 90,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
          ]),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_getRankLabel(card.rank),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            Icon(_getSuitIcon(card.suit),
                color: _getSuitColor(card.suit), size: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 60,
      height: 90,
      decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
          ]),
      child: const Center(
          child: Icon(Icons.help_outline, color: Colors.white, size: 30)),
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  String _getRankLabel(rank_model.Rank rank) {
    switch (rank) {
      case rank_model.Rank.ace: return "A";
      case rank_model.Rank.jack: return "J";
      case rank_model.Rank.queen: return "Q";
      case rank_model.Rank.king: return "K";
      default: return (rank.index + 1).toString();
    }
  }

  IconData _getSuitIcon(suit_model.Suit suit) {
    switch (suit) {
      case suit_model.Suit.hearts: return Icons.favorite;
      case suit_model.Suit.diamonds: return Icons.diamond;
      case suit_model.Suit.clubs: return Icons.cloud;
      case suit_model.Suit.spades: return Icons.auto_awesome;
    }
  }

  Color _getSuitColor(suit_model.Suit suit) {
    return (suit == suit_model.Suit.hearts || suit == suit_model.Suit.diamonds)
        ? Colors.red
        : Colors.black;
  }
}
