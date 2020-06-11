import 'package:flutter/material.dart';
import 'package:transport_booking_system_conductor_mobile/views/screens/bus_layouts/bus_layout1.dart';
import 'package:transport_booking_system_conductor_mobile/views/screens/bus_layouts/bus_layout2.dart';
import 'package:transport_booking_system_conductor_mobile/views/screens/bus_layouts/bus_layout3.dart';
import 'package:transport_booking_system_conductor_mobile/views/screens/bus_layouts/bus_layout4.dart';

class BusLayoutWrapper extends StatefulWidget {
  final String uid;
  final String token;
  final String tripId;
  final String busType;
  BusLayoutWrapper({this.uid, this.token, this.tripId, this.busType});

  @override
  _BusLayoutWrapperState createState() => _BusLayoutWrapperState();
}

class _BusLayoutWrapperState extends State<BusLayoutWrapper> {
  @override
  Widget build(BuildContext context) {
      Widget layout; // return the layout according to the type of the bus
      if (widget.busType == "Luxury bus"){ //type 1 bus
        layout = BusLayout1(uid:widget.uid, token:widget.token, tripId: widget.tripId, busType: widget.busType);
      }
      if (widget.busType == "AC bus"){ //type 2 bus
        layout = BusLayout2(uid:widget.uid, token:widget.token, tripId: widget.tripId, busType: widget.busType);
      }
      if (widget.busType == "3x2 bus"){ //type 3 bus
        layout = BusLayout3(uid:widget.uid, token:widget.token, tripId: widget.tripId, busType: widget.busType);
      }
      if (widget.busType == "2x2 bus"){ //type 4 bus
        layout = BusLayout4(uid:widget.uid, token:widget.token, tripId: widget.tripId, busType: widget.busType);
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text(
            'Seat Bookings',
            style: TextStyle(
              color: Colors.white
            ),
          )
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Menu()
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration( 
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.grey[400], 
                ),
                width: double.infinity,
                margin: EdgeInsets.all(10.0),
                child: Center(
                  key: Key('front'),
                  child: Text(
                    'Front', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.grey[700],
                    ),
                  )
                )
              ),
            ),
            Expanded(
              flex: 8,
              child: layout,
            ),
          ],
        ),
      );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration( 
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.amber[400], 
                    ),
                    margin: EdgeInsets.fromLTRB(40.0,0.0,40.0,0),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration( 
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.green[500],
                    ),
                    margin: EdgeInsets.fromLTRB(40.0,0.0,40.0,0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Text(
                      'Booked', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontSize: 15.0
                      ),
                    )
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Text(
                      'Available', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontSize: 15.0
                      ),
                    )
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}