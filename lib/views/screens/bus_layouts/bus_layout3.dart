import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:transport_booking_system_conductor_mobile/controllers/auth_controller.dart';
import 'package:transport_booking_system_conductor_mobile/models/api_response.dart';
import 'package:transport_booking_system_conductor_mobile/models/bus_seat.dart';
import 'package:transport_booking_system_conductor_mobile/views/shared_widgets/page_widget.dart';
import 'package:transport_booking_system_conductor_mobile/views/shared_widgets/single_bus_seat.dart';

class BusLayout3 extends StatefulWidget {
  final String uid;
  final String token;
  final String tripId;
  final String busType;
  BusLayout3({this.uid, this.token, this.tripId, this.busType});
  
  @override
  _BusLayout3State createState() => _BusLayout3State();
}

class _BusLayout3State extends State<BusLayout3> {
  final AuthController _auth = AuthController();
  APIResponse<List<BusSeat>> _apiResponse;
  bool _isLoading;
  List<BusSeat> seatBookings; 
  String errorMessage;

  @override
  void initState() {
    _fetchSeatDetails();
    super.initState();
  }

  _fetchSeatDetails() async {
    setState(() { _isLoading = true; });
    // get seat details of the particular trip
    IOClient client = IOClient();
    _apiResponse = await _auth.getBookings(client, widget.uid, widget.token, widget.tripId);
    setState(() { 
      if (_apiResponse.error){
        _isLoading = false; 
        errorMessage = _apiResponse.errorMessage;
      } else {
        _isLoading = false; 
        seatBookings = _apiResponse.data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading? Center(child: LoadingWidget()) : 
        _apiResponse.error? Text(_apiResponse.errorMessage) : Column(
        children: generateExpanded(context),
      ),
    );
  }

  // create the bus layout
  List<Widget> generateExpanded(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < 41; i = i+5) {
      children.add(Expanded(
        flex: 1,
        child: busRow(context, i),
      ));
    }
    children.add(Expanded(
      flex: 1,
      child: oneBeforeLastRow(context, 45),
    ));
    children.add(Expanded(
      flex: 1,
      child: lastRow(context, 48),
    ));
    return children;  
  }

  Widget busRow (BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index, seatBookings: seatBookings)),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+1, seatBookings: seatBookings)),
        Expanded(flex:1,child: SizedBox()),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+2, seatBookings: seatBookings)),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+3, seatBookings: seatBookings)),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+4, seatBookings: seatBookings)),
      ],
    );
  }

  Widget oneBeforeLastRow (BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(flex:1,child: SizedBox()),
        Expanded(flex:1,child: SizedBox()),
        Expanded(flex:1,child: SizedBox()),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index, seatBookings: seatBookings)),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+1, seatBookings: seatBookings)),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+2, seatBookings: seatBookings)),
      ],
    );
  }

  Widget lastRow (BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index, seatBookings: seatBookings)),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+1, seatBookings: seatBookings)),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+2, seatBookings: seatBookings)),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+3, seatBookings: seatBookings)),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+4, seatBookings: seatBookings)),
        Expanded(flex:1,child: SingleBusSeat(uid:widget.uid, token:widget.token, tripId: widget.tripId, index: index+5, seatBookings: seatBookings)),
      ],
    );
  }
}