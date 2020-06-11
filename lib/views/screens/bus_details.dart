import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:transport_booking_system_conductor_mobile/controllers/auth_controller.dart';
import 'package:transport_booking_system_conductor_mobile/models/api_response.dart';
import 'package:transport_booking_system_conductor_mobile/models/bus_trip_data.dart';
import 'package:transport_booking_system_conductor_mobile/shared_functions.dart';
import 'package:transport_booking_system_conductor_mobile/views/bus_layout_wrapper.dart';
import 'package:transport_booking_system_conductor_mobile/views/shared_widgets/page_widget.dart';

class BusDetails extends StatefulWidget {
  final String uid;
  final String token;
  BusDetails({this.uid, this.token});

  @override
  _BusDetailsState createState() => _BusDetailsState();
}

class _BusDetailsState extends State<BusDetails> {
  final AuthController _auth = AuthController();
  APIResponse<List<BusTripData>> _apiResponse;
  SharedFunctions sharedFunctions = SharedFunctions();
  List<BusTripData> activeTrips;
  BusTripData currentTrip;
  String tripState;
  bool _isLoading;
  String tripStatus;
  String errorMessage;

  @override
  void initState() {
    _fetchBusDetails();
    super.initState();
  }

  _fetchBusDetails() async {
    setState(() { _isLoading = true; });
    IOClient client = IOClient();
    _apiResponse = await _auth.getActiveTurns(client, widget.uid, widget.token);
    setState(() { 
      _isLoading = false; 
      if (_apiResponse.error){
        errorMessage = _apiResponse.errorMessage;
      } else {
        activeTrips = _apiResponse.data;
        if (activeTrips.length != 0) {
          activeTrips.sort((a, b) => sharedFunctions.getTimeDifference(a.departureTime).compareTo(sharedFunctions.getTimeDifference(b.departureTime)));
          currentTrip = activeTrips[0];
          if(sharedFunctions.getTimeDifference(currentTrip.departureTime) < 0) {
            tripStatus = "Ongoing";
          } else {
            tripStatus = "Pending";
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading? Center(child: LoadingWidget()) : 
      SingleChildScrollView(
        child: _apiResponse.error? Card(
          margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                child: FlatButton.icon(
                  icon: Icon(Icons.refresh),
                  label: Text(
                    'Refresh',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () async {
                    // to load all th bus details and the trip details again
                    _fetchBusDetails();
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: Text(
                    "$errorMessage",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ) : Card(
          color: Colors.grey[100],
          margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
          child: activeTrips.length == 0 ? Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: Text(
                "No current trips assigned",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green[900],
                ),
                textAlign: TextAlign.center,
              ),
            )
          ) : Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                child: FlatButton.icon(
                  key: Key('refresh-button'),
                  icon: Icon(Icons.refresh),
                  label: Text(''),
                  onPressed: () async {
                    // to load all th bus details and the trip details again
                    _fetchBusDetails();
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Bus Number',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  currentTrip.busNumber, // get the nearest upcoming trip from the list
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Bus Type',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  currentTrip.busType,
                  style: TextStyle(
                    fontSize: 20.0, 
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '${currentTrip.startStation} to ${currentTrip.endStation}',
                  style: TextStyle(
                    fontSize: 20.0, 
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Departure Date and Time',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  sharedFunctions.formatDateTime(currentTrip.departureTime),
                  style: TextStyle(
                    fontSize: 20.0, 
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Arrival Date and Time',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  sharedFunctions.formatDateTime(currentTrip.arrivalTime),
                  style: TextStyle(
                    fontSize: 20.0, 
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Normal Seat Price',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  'LKR ${currentTrip.normalSeatPrice.toString()}',
                  style: TextStyle(
                    fontSize: 20.0, 
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Trip Status',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  tripStatus,
                  style: TextStyle(
                    fontSize: 20.0, 
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: FlatButton.icon(
                    key: Key('booking-button'), // to view the bookings of the current trip
                    label: Text(
                      'View Bookings',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    color: Colors.green[700],
                    textColor: Colors.white,
                    icon: Icon(Icons.dashboard),
                    onPressed: () { 
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BusLayoutWrapper(uid: widget.uid, token: widget.token, tripId: currentTrip.tripId, busType: currentTrip.busType)));   
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ));
  }

}