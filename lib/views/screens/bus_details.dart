import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:transport_booking_system_conductor_mobile/controllers/auth_controller.dart';
import 'package:transport_booking_system_conductor_mobile/models/api_response.dart';
import 'package:transport_booking_system_conductor_mobile/models/bus_trip_data.dart';
import 'package:transport_booking_system_conductor_mobile/views/bus_layout_wrapper.dart';
import 'package:intl/intl.dart';

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
  List<BusTripData> activeTrips;
  BusTripData currentTrip;
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
          int minDifference = _getTimeDifference(activeTrips[0].departureTime);
          currentTrip = activeTrips[0];
          for(var i=0; i<activeTrips.length;i++){
            if (_getTimeDifference(activeTrips[i].departureTime) < 0) {
              currentTrip = activeTrips[i];
              break;
            }
            else {
              int difference = _getTimeDifference(activeTrips[i].departureTime);
              if (difference < minDifference) {
                minDifference = difference;
                currentTrip = activeTrips[i];
              }
            }
          }
        }
      }
    });
  }

  _getTimeDifference(String dateTime) {
    DateTime dt = DateTime.parse(dateTime.substring(0,19));
    dt = dt.add(Duration(hours: 5,minutes: 30));
    DateTime now = new DateTime.now();
    String nowString1 = now.toString();
    String nowString2 = nowString1.substring(0,10) + 'T' + nowString1.substring(11,19);
    DateTime dtnow = DateTime.parse(nowString2);
    int difference = dt.difference(dtnow).inMinutes;
    return (difference);
  }

  _formatDateTime(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    dt = dt.add(Duration(hours: 5,minutes: 30));
    String date = DateFormat.yMd().format(dt);
    String time = DateFormat.jm().format(dt);
    return ('$date at $time');
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading? Center(child: CircularProgressIndicator()) : 
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
              ListTile(
                title: Text(
                  'Bus Number',
                  style: TextStyle(fontSize: 20.0),
                ),
                subtitle: Text(
                  currentTrip.busNumber, // get the nearest upcoming trip from the list
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text(
                  'Bus Type',
                  style: TextStyle(fontSize: 20.0),
                ),
                subtitle: Text(
                  currentTrip.busType,
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text(
                  '${currentTrip.startStation} to ${currentTrip.endStation}',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              ListTile(
                title: Text(
                  'Departure Date and Time',
                  style: TextStyle(fontSize: 20.0),
                ),
                subtitle: Text(
                  _formatDateTime(currentTrip.departureTime),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text(
                  'Arrival Date and Time',
                  style: TextStyle(fontSize: 20.0),
                ),
                subtitle: Text(
                  _formatDateTime(currentTrip.arrivalTime),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text(
                  'Normal Seat Price',
                  style: TextStyle(fontSize: 20.0),
                ),
                subtitle: Text(
                  'LKR ${currentTrip.normalSeatPrice.toString()}',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Trip Status',
                style: TextStyle(fontSize: 20.0),
              ),
              FlatButton(
                child: Text(
                  'pending',
                  style: TextStyle(fontSize: 17.0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                ),
                color: Colors.green[700],
                textColor: Colors.white,
                onPressed: () { 
                  _showBottomSheet(); // a bottom sheet to update the status of the trip
                },
              ),
              SizedBox(height: 15.0),
              FlatButton.icon( // to view the bookings of the current trip
                label: Text(
                  'View Bookings',
                  style: TextStyle(fontSize: 20.0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                ),
                color: Colors.green[700],
                textColor: Colors.white,
                icon: Icon(Icons.dashboard),
                onPressed: () { 
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BusLayoutWrapper(uid: widget.uid, token: widget.token, tripId: currentTrip.tripId, busType: currentTrip.busType)));   
                },
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ));
  }

  void _showBottomSheet() async{
    showModalBottomSheet(context: context, builder: (context) {
      return StatefulBuilder( // to update the bottom sheet itself when set state is called
        builder: (BuildContext context, StateSetter setState){
          return Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Update the trip status',
                  style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 20.0),
                ListTile(
                title: Text(
                  'pending',
                  style: TextStyle(fontSize: 17.0),
                ),
                leading: Radio(
                  value: "pending",
                  groupValue: tripStatus,
                  activeColor: Colors.green,
                  onChanged: (value) { 
                    setState(() {
                      tripStatus = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'started',
                  style: TextStyle(fontSize: 17.0),
                ),
                leading: Radio(
                  value: "started",
                  groupValue: tripStatus,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    this.setState(() { tripStatus = value;});
                    setState(() {
                      tripStatus = value; 
                    });   
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'finished',
                  style: TextStyle(fontSize: 17.0),
                ),
                leading: Radio(
                  value: "finished",
                  groupValue: tripStatus,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {   
                      tripStatus = value; 
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  "cancelled",
                  style: TextStyle(fontSize: 17.0),
                ),
                leading: Radio(
                  value: "cancelled",
                  groupValue: tripStatus,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      tripStatus = value;   
                    });
                  },
                ),
              ),
              FlatButton(
                child: Text(
                  "Update",
                  style: TextStyle(fontSize: 20.0)
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                ),
                onPressed: () {
                  // send a put request to the api to update the trip status
                  Navigator.of(context).pop();
                  _fetchBusDetails();
                },
                color: Colors.green[700],
                textColor: Colors.white,
              ),
            ],
           ),
          );
        }
      ); 
    });
  }  
}