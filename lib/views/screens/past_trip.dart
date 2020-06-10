import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:transport_booking_system_conductor_mobile/controllers/auth_controller.dart';
import 'package:transport_booking_system_conductor_mobile/models/api_response.dart';
import 'package:transport_booking_system_conductor_mobile/models/bus_trip_data.dart';
import 'package:transport_booking_system_conductor_mobile/views/shared_functions.dart';
import 'package:transport_booking_system_conductor_mobile/views/shared_widgets/page_widget.dart';

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
  SharedFunctions sharedFunctions = SharedFunctions();
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
        // to get the most recent past trip first in the list
        pastTrips.sort((a, b) => sharedFunctions.getTimeDifference(b.departureTime).compareTo(sharedFunctions.getTimeDifference(a.departureTime)));
      }
    });
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

  final SharedFunctions sharedFunctions = SharedFunctions();

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
              '${sharedFunctions.formatDateTime(pastTrip.departureTime)} to ${sharedFunctions.formatDateTime(pastTrip.arrivalTime)}',
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