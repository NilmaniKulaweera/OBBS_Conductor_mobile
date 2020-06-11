import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_booking_system_conductor_mobile/views/screens/bus_details.dart';
import 'package:transport_booking_system_conductor_mobile/views/screens/future_trip.dart';
import 'package:transport_booking_system_conductor_mobile/views/screens/past_trip.dart';
import 'package:transport_booking_system_conductor_mobile/views/screens/sign_in.dart';
import 'package:transport_booking_system_conductor_mobile/views/shared_widgets/page_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  SharedPreferences sharedPreferences;
  String uid;
  String token;
  bool _isLoading = true;
  static const String futureTrips = "Future Trips";
  static const String pastTrips = "Past Trips";
  static const List<String> choices = <String>[futureTrips, pastTrips];
  
  @override
  void initState() { 
    checkLoginStatus();
    super.initState();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn())); // if user is not logged in navigate to sign in page
    } else {
      setState(() { _isLoading = true; });
      uid = sharedPreferences.getString("uid");
      token = sharedPreferences.getString("token");
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading? Center(child: LoadingWidget()) : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Center(
          child: PageTitleHomePage()
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Log Out", 
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            onPressed: () {
              sharedPreferences.clear(); // clear cache data
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn())); 
            },  
          ), 
          PopupMenuButton<String>(
              key: Key('menu-button'),
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                    key: Key('popup $choice'),
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            PageLowerHalf(),
            PageUpperHalf(),
            BusDetails(uid: uid, token: token),
          ],
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == pastTrips){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PastTrip(uid: uid, token: token)));
    }
    if (choice == futureTrips){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => FutureTrip(uid: uid, token: token)));
    }
  }
}