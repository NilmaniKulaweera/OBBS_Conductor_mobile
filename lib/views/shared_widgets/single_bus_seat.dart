import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:transport_booking_system_conductor_mobile/controllers/auth_controller.dart';
import 'package:transport_booking_system_conductor_mobile/models/api_response.dart';
import 'package:transport_booking_system_conductor_mobile/models/bus_seat.dart';
import 'package:transport_booking_system_conductor_mobile/models/passenger.dart';

class SingleBusSeat extends StatefulWidget {
  final String uid;
  final String token;
  final String tripId;
  final int index;
  final List<BusSeat> seatBookings;
  SingleBusSeat({this.uid, this.token, this.tripId, this.index, this.seatBookings});

  @override
  _SingleBusSeatState createState() => _SingleBusSeatState();
}

class _SingleBusSeatState extends State<SingleBusSeat> {
  final AuthController _auth = AuthController();
  APIResponse<Passenger> _apiResponse;
  Passenger passenger;
  bool _isLoading;
  String seatId;
  String errorMessage;

  @override
  void initState() {
    _fetchPassengerDetails();
    super.initState();
  }

  _fetchPassengerDetails() async {
    setState(() { 
      _isLoading = true; 
      seatId = widget.seatBookings[widget.index].seatID;
    });
    IOClient client = IOClient();
    _apiResponse = await _auth.getPassengerDetails(client, widget.uid, widget.token, widget.tripId, seatId);
    setState(() { 
      if (_apiResponse.error) {
        _isLoading = false; 
        errorMessage = _apiResponse.errorMessage; 
      } else {
        passenger = _apiResponse.data;
        _isLoading = false; 
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading? Center(child: CircularProgressIndicator()) : Container(
      margin:EdgeInsets.symmetric(horizontal:10.0,vertical: 5.0),
      child: FlatButton(
        padding: const EdgeInsets.all(0),
        child: Center(
          child: Text(
            seatId,
            style: TextStyle(color: Colors.grey[900]),
          )
        ),
        color: widget.seatBookings[widget.index].status == "Unavailable"? Colors.amber[400] : Colors.green[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        onPressed: () async { // when a seat is pressed, show a dialog box containing details of the passenger who booked that seat
          final result = await showDialog(
            context: context,
            builder: (context) => !_apiResponse.error? AlertDialog(
              title: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text('Seat No: $seatId - ${passenger.passengerName}'),
                subtitle: Text('${passenger.passengerPhone}'),
              ),
              content: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text('${passenger.startStation} - ${passenger.endStation}'),
                subtitle: Text('LKR ${widget.seatBookings[widget.index].price}'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ) : AlertDialog(
              title: Text('Seat No: $seatId - $errorMessage'),
              content: Text('LKR ${widget.seatBookings[widget.index].price}'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          );
          return result;
        }, 
      ),
    );
  }
}

