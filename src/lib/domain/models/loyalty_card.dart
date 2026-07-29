class LoyaltyCard {
  int stampCount;

  LoyaltyCard({this.stampCount = 0});

  void increment() {
    if (stampCount < 8) stampCount++;
  }

  void reset() {
    if (stampCount == 8) stampCount = 0;
  }

  Map<String, dynamic> toJson() => {'stampCount': stampCount};

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) =>
      LoyaltyCard(stampCount: json['stampCount'] as int);
}
