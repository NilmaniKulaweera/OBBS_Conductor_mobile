class Passenger {
  String passengerName;
  String passengerPhone;
  String startStation;
  String endStation;

  Passenger({
    this.passengerName, 
    this.passengerPhone, 
    this.startStation, 
    this.endStation
  });

  factory Passenger.fromJson(Map<String,dynamic> passenger)  {
    return Passenger(
      passengerName: passenger['passengerName'],
      passengerPhone: passenger['passengerPhone'],
      startStation: passenger['startStation'],
      endStation: passenger['endStation'], 
    );
  }

}