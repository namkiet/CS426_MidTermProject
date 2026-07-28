class LoyaltyCard {
  int stampCount;

  LoyaltyCard({this.stampCount = 0});

  void increment() {
    if (stampCount < 8) {
      stampCount++;
    }
  }

  void reset() {
    if (stampCount == 8) {
      stampCount = 0;
    }
  }
}
