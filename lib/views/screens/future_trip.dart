import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:transport_booking_system_conductor_mobile/controllers/auth_controller.dart';
import 'package:transport_booking_system_conductor_mobile/models/api_response.dart';
import 'package:transport_booking_system_conductor_mobile/models/bus_trip_data.dart';
import 'package:transport_booking_system_conductor_mobile/views/bus_layout_wrapper.dart';
import 'package:transport_booking_system_conductor_mobile/views/shared_functions.dart';
import 'package:transport_booking_system_conductor_mobile/views/shared_widgets/page_widget.dart';

class FutureTrip extends StatefulWidget {
  final String uid;
  final String token;
  FutureTrip({this.uid, this.token});

  @override
  _FutureTripState createState() => _FutureTripState();
}

class _FutureTripState extends State<FutureTrip> {
  final AuthController _auth = AuthController();
  APIResponse<List<BusTripData>> _apiResponse;
  SharedFunctions sharedFunctions = SharedFunctions();
  List<BusTripData> activeTrips; 
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
    _apiResponse = await _auth.getActiveTurns(client, widget.uid, widget.token);
    setState(() { 
      _isLoading = false; 
      if (_apiResponse.error){
        errorMessage = _apiResponse.errorMessage;
      } else {
        activeTrips = _apiResponse.data;
        activeTrips.sort((a, b) => sharedFunctions.getTimeDifference(a.departureTime).compareTo(sharedFunctions.getTimeDifference(b.departureTime)));
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text(
            'Future Trips',
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
                ) : activeTrips.length == 0 ? SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
                    color: Colors.grey[100],
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: Text(
                          "No future trips assigned",
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
                  itemCount: activeTrips.length,
                  itemBuilder: (context, index) {
                    return FutureTripTile(uid:widget.uid, token:widget.token, futureTrip: activeTrips[index]);
                  }
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class FutureTripTile extends StatelessWidget {
  final String uid;
  final String token;
  final BusTripData futureTrip;
  FutureTripTile({this.uid, this.token, this.futureTrip});

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
              '${futureTrip.busNumber} ${futureTrip.startStation} to ${futureTrip.endStation}',
            ),
            subtitle: Text(
              '${sharedFunctions.formatDateTime(futureTrip.departureTime)} to ${sharedFunctions.formatDateTime(futureTrip.arrivalTime)}',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BusLayoutWrapper(uid: uid, token: token, tripId: futureTrip.tripId, busType: futureTrip.busType)));   
            },
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }             
}