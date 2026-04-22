enum Popupmsg {
  loose("Oups ! Vous avez dépassé 21."),
  win("Gagné !"),
  dealerLoose("Le croupier a sauté ! Vous gagnez."),
  dealerWinByBJ("Le croupier a un Blackjack. Perdu."),
  push("Égalité !"),
  blackjack("BLACKJACK !"),
  congratulation("Félicitations !"),
  resultat("Résultat"),
  hit("HIT"),
  stand("STAND"),
  mise("Mise : "),
  play("JOUER "),
  playeur("Joueur"),
  dealer("Croupier"),
  necessaryCoins("Pas assez de jetons !"),
  good("OK"),
  euro("€"),
  score("Score : "),
  banque("Banque : "),
  looseByScore("Perdu ..."),
  name("Veuillez entrer un nom"),
  bj("BLACKJACK"),
  turn("QUI JOUE ?"),
  coins("Jetons"),
  min("MIN : 50");



  final String message;

  const Popupmsg(this.message);
}