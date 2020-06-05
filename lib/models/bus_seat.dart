class BusSeat {
  String seatID;
  String status;
  String seatType;
  int price;
  dynamic booking;

  BusSeat({this.seatID, this.status, this.seatType, this.price, this.booking});

  factory BusSeat.fromJson(Map<String,dynamic> seat)  {
    return BusSeat(
      seatID: seat['id'],
      status: seat['status'],
      seatType: seat['seatType'],
      price: seat['price'], 
      booking: seat['booking'],
    );
  }
}