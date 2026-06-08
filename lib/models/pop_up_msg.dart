enum PopUpMsg {
  loose("Oups ! Vous avez dépassé 21. \n Vous avez perdu : "),
  win("Félicitations !  \n Vous avez gagné :"),
  dealerLoose("Le croupier a sauté !  \n Vous avez gagné :"),
  dealerWinByBJ("Le croupier a un Blackjack.  \n Vous avez perdu : "),
  push("Égalité !  \n Chacun récupère sa mise"),
  blackjack("BLACKJACK !  \n Vous avez gagné : "),
  congratulation("Félicitations !"),
  resultat("Résultat"),
  hit("HIT"),
  stand("STAND"),
  mise("Mise : "),
  play("JOUER "),
  player("Joueur"),
  dealer("Croupier"),
  necessaryCoins("Pas assez de jetons !"),
  good("OK"),
  euro("€"),
  score("Score : "),
  banque("Banque : "),
  looseByScore("Perdu ..."),
  name("Veuillez entrer un nom valide"),
  password("Mot de passe"),
  passwordInvalid("Mot de passe incorrect. \n Veuillez recommencer"),
  bj("BLACKJACK"),
  turn("QUI JOUE ?"),
  coins("Jetons"),
  cancel("Annuler"),
  min("MIN : 50");



  final String message;

  const PopUpMsg(this.message);
}