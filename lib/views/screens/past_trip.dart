import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:transport_booking_system_conductor_mobile/controllers/auth_controller.dart';
import 'package:transport_booking_system_conductor_mobile/models/api_response.dart';
import 'package:transport_booking_system_conductor_mobile/models/bus_trip_data.dart';
import 'package:transport_booking_system_conductor_mobile/views/shared_widgets/page_widget.dart';
import 'package:intl/intl.dart';

class PastTrip extends StatefulWidget {
  final String uid;
  final String token;
  PastTrip({this.uid, this.token});

  @override
  _PastTripState createState() => _PastTripState();
}

class _PastTripState extends State<PastTrip> {
  final AuthController _auth = AuthController();
  APIResponse<List<BusTripData>> _apiResponse;
  List<BusTripData> pastTrips; 
  bool _isLoading;
  String errorMessage;

  @override
  void initState() {
    _fetchBusDetails();
    super.initState();
  }

  _fetchBusDetails() async {
    setState(() { _isLoading = true; });
    IOClient client = IOClient();
    _apiResponse = await _auth.getPastTurns(client, widget.uid, widget.token);
    setState(() { 
      _isLoading = false; 
      if (_apiResponse.error){
        errorMessage = _apiResponse.errorMessage;
      } else {
        pastTrips = _apiResponse.data;
        pastTrips.sort((a, b) => _getTimeDifference(a.departureTime).compareTo(_getTimeDifference(b.departureTime)));
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
    int difference = dtnow.difference(dt).inMinutes;
    return (difference);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text(
            'Past Trips',
            style: TextStyle(
              color: Colors.white
            ),
          )
        ),
      body: Container(
        child: Stack(
          children: <Widget>[
            PageLowerHalf(),
            PageUpperHalf(),
            _isLoading? Center(child: CircularProgressIndicator()) : Container(
                child: _apiResponse.error? SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
                    color: Colors.grey[100],
                    child: Center(
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
                  ),
                ) : pastTrips.length == 0 ? SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
                    color: Colors.grey[100],
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: Text(
                          "No past trips",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ) : 
                ListView.builder(
                  itemCount: pastTrips.length,
                  itemBuilder: (context, index) {
                    return PastTripTile(pastTrip: pastTrips[index]);
                  }
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class PastTripTile extends StatelessWidget {
  final BusTripData pastTrip;
  PastTripTile({this.pastTrip});

  _formatDateTime(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    dt = dt.add(Duration(hours: 5,minutes: 30));
    String date = DateFormat.yMd().format(dt);
    String time = DateFormat.jm().format(dt);
    return ('$date at $time');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 15.0),
          ListTile(
            leading: Icon(
              Icons.airport_shuttle,
              color: Colors.grey[700],
            ),
            title: Text(
              '${pastTrip.busNumber} ${pastTrip.startStation} to ${pastTrip.endStation}',
            ),
            subtitle: Text(
              '${_formatDateTime(pastTrip.departureTime)} to ${_formatDateTime(pastTrip.arrivalTime)}',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }             
}