import 'package:blackjack/Models/deck52.dart';
import 'package:blackjack/Models/card.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:blackjack/Models/player.dart';
import 'package:blackjack/Models/suit.dart' as suit_model;
import 'package:blackjack/Models/rank.dart' as rank_model;
import 'package:blackjack/Services/JoueurService.dart';

import '../Models/PopupMsg.dart';

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
    player = joueurService.getPlayer() ?? Player(Popupmsg.playeur.message, 100, false);
    dealer = Player(Popupmsg.dealer.message, 0, true);
    deck = Deck52();
    isGameInProgress = false;
    showDealerHiddenCard = false;
    
    if (currentBet > player.coins) {
      currentBet = player.coins < 10 ? 10 : (player.coins ~/ 10) * 10;
    }
    if (currentBet < 10) currentBet = 10;
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
        SnackBar(content: Text(Popupmsg.necessaryCoins.message)),
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
      joueurService.savePlayer(player);
      showDealerHiddenCard = false;
      isGameInProgress = true;

      _drawCard(player);
      _drawCard(player);
      _drawCard(dealer);
      _drawCard(dealer);

      if (player.score == 21) {
        _stand();
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
        _showResultDialog(Popupmsg.loose.message, isWin: false);
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
      message = Popupmsg.loose.message;
    } else if (dealer.score > 21) {
      message = Popupmsg.dealerLoose.message;
      player.coins += playerBJ ? (player.bet * 2.5).toInt() : (player.bet * 2);
      isWin = true;
    } else if (playerBJ && !dealerBJ) {
      message = Popupmsg.blackjack.message;
      player.coins += (player.bet * 2.5).toInt();
      isWin = true;
    } else if (dealerBJ && !playerBJ) {
      message = Popupmsg.dealerWinByBJ.message;
    } else if (player.score > dealer.score) {
      message = Popupmsg.win.message;
      player.coins += player.bet * 2;
      isWin = true;
    } else if (player.score < dealer.score) {
      message = "${Popupmsg.looseByScore.message} ${player.score} vs ${dealer.score}";
    } else {
      message = Popupmsg.push.message;
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
        title: Text(isWin ? Popupmsg.congratulation.message : Popupmsg.resultat.message),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initGameData();
              setState(() {});
            },
            child: Text(Popupmsg.good.message),
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
        toolbarHeight: 40,
        backgroundColor: Colors.black26,
        elevation: 0,
        title: Text("${Popupmsg.banque.message}${player.coins} ${Popupmsg.euro.message}",
            style: const TextStyle(color: Colors.yellowAccent, fontSize: 16)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    _buildDealerSection(),
                    const Divider(color: Colors.white10, height: 20),
                    _buildPlayerSection(player),
                  ],
                ),
              ),
            ),
            _buildActionPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildDealerSection() {
    return Column(
      children: [
        Text(dealer.name,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(dealer.hand.length, (index) {
            if (index == 1 && !showDealerHiddenCard && isGameInProgress) {
              return _buildCardBack();
            }
            return _buildCard(dealer.hand[index]);
          }),
        ),
        Text(
            "${Popupmsg.score.message}${showDealerHiddenCard ? dealer.score : (dealer.hand.isNotEmpty ? _calculateScore([dealer.hand[0]]) : 0)}",
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildPlayerSection(Player p) {
    return Column(
      children: [
        Text(p.name,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: p.hand.map((card) => _buildCard(card)).toList(),
        ),
        Text("${Popupmsg.score.message}${p.score} | ${Popupmsg.mise.message}${p.bet}${Popupmsg.euro.message}",
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }

  Widget _buildActionPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.black45,
      child: isGameInProgress
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Popupmsg.hit.message, Colors.blue, _hit),
                _actionButton(Popupmsg.stand.message, Colors.orange, _stand),
              ],
            )
          : Row(
              children: [
                Text(Popupmsg.mise.message, style: TextStyle(color: Colors.white, fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: currentBet.toDouble().clamp(10.0, player.coins >= 10 ? player.coins.toDouble() : 10.0),
                    min: 10,
                    max: player.coins >= 10 ? player.coins.toDouble() : 10.0,
                    divisions: player.coins > 20 ? (player.coins / 10).floor() : 1,
                    onChanged: (v) => setState(() => currentBet = v.toInt()),
                  ),
                ),
                Text("${currentBet} ${Popupmsg.euro.message}",
                    style: const TextStyle(color: Colors.yellowAccent, fontSize: 14)),
                const SizedBox(width: 10),
                _actionButton(
                    Popupmsg.play.message, Colors.yellow[800]!, _startNewRound),
              ],
            ),
    );
  }

  Widget _buildCard(Card card) {
    return Container(
      width: 50,
      height: 75,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 2, offset: Offset(1, 1))
          ]),
      child: Stack(
        children: [
          Positioned(
            top: 2,
            left: 2,
            child: Text(_getRankLabel(card.rank),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: _getSuitColor(card.suit))),
          ),
          Center(
            child: Icon(_getSuitIcon(card.suit),
                color: _getSuitColor(card.suit), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 50,
      height: 75,
      decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white24, width: 1.5),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 2, offset: Offset(1, 1))
          ]),
      child: const Center(
          child: Icon(Icons.help_outline, color: Colors.white30, size: 20)),
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        minimumSize: const Size(80, 40),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
