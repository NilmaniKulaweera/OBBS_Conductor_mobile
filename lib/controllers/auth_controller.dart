import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transport_booking_system_conductor_mobile/constants.dart';
import 'package:transport_booking_system_conductor_mobile/models/api_response.dart';
import 'package:transport_booking_system_conductor_mobile/models/bus_seat.dart';
import 'package:transport_booking_system_conductor_mobile/models/bus_trip_data.dart';
import 'package:transport_booking_system_conductor_mobile/models/passenger.dart';
import 'package:transport_booking_system_conductor_mobile/models/user_data.dart';

class AuthController {

  Future<APIResponse<UserData>> signInUser(http.Client client, String email, String password) async {
    // sign in the conductor when the email and password is given
    String url = Constants.SERVER;

    return client.post(
      '$url/signin',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      })
    ).then ((response) {
        client.close();
        if(response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          // convert the response to a custom user object
          if (UserData.fromJson(data).role == "CONDUCTOR") { 
            print (UserData.fromJson(data).uid);
            print (UserData.fromJson(data).token);
            print (UserData.fromJson(data).phoneNumber);
            print (UserData.fromJson(data).role);
            return APIResponse<UserData>(data: UserData.fromJson(data)); 
          } else {
            return APIResponse<UserData>(error: true, errorMessage: 'Not a valid conductor');
          }
        }
        if(response.statusCode == 400) {
          final error = jsonDecode(response.body);
          return APIResponse<UserData>(error: true, errorMessage: error['error']);
        }
        return APIResponse<UserData>(error: true, errorMessage: 'An error occured');
      }).
      catchError((error) {
        client.close();
        return APIResponse<UserData> (error: true, errorMessage: 'An error occured');
      }); 
  }

  Future<APIResponse<List<BusTripData>>> getActiveTurns(http.Client client, String uid, String loginToken) async {
    // get the current and upcoming active turns assigned to the conductor
    String url = Constants.SERVER;
    String token = loginToken;
    List<BusTripData> activeTurns = [];
    return await client.get(
      '$url/getactiveturns/$uid',
      
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    ).then ((response) {
      client.close();
      if(response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        for(var i=0; i<data["turns"].length;i++){
          activeTurns.add(BusTripData.fromJson(data["turns"][i]));
        }
        return APIResponse<List<BusTripData>>(data: activeTurns);
      } 
      if(response.statusCode == 400) {
        final error = jsonDecode(response.body);
        return APIResponse<List<BusTripData>>(error: true, errorMessage: error['error']);
      }
      return APIResponse<List<BusTripData>>(error: true, errorMessage: 'An error occured');
    }).
    catchError((error) {
      client.close();
      return APIResponse<List<BusTripData>>(error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<List<BusSeat>>> getBookings(http.Client client, String uid, String loginToken, String tripId) async {
    // get the current seat bookings of the trip
    String url = Constants.SERVER;
    String token = loginToken;
    List<BusSeat> seatBookings = [];
    List<BusSeat> orderedSeatBookings = [];
    
    return await client.post(
      '$url/getseatdetailsbyconductor/$uid',
      
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'turnId': tripId,
      })
    ).then ((response) {
      client.close();
      if(response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        for(var i=0; i<data["seats"].length;i++){
          seatBookings.add(BusSeat.fromJson(data["seats"][i]));
        }
        for (var i=0; i<seatBookings.length;i++){
          for (var j=0; j<seatBookings.length;j++){
            if (int.parse(seatBookings[j].seatID) == i+1){
              orderedSeatBookings.add(seatBookings[j]);
              break;
            } 
          }
        }
        return APIResponse<List<BusSeat>>(data: orderedSeatBookings);
      } 
      if(response.statusCode == 400) {
        final error = jsonDecode(response.body);
        return APIResponse<List<BusSeat>>(error: true, errorMessage: error['error']);
      }
      return APIResponse<List<BusSeat>>(error: true, errorMessage: 'An error occured');
    }).
    catchError((error) {
      client.close();
      return APIResponse<List<BusSeat>>(error: true, errorMessage: 'An error occured');
    });
   }

  Future<APIResponse<Passenger>> getPassengerDetails(http.Client client, String uid, String loginToken, String tripId, String seatId) async {
    // get the details of the passenger who booked a particular seat
    String url = Constants.SERVER;
    String token = loginToken;

    return client.post(
      '$url/getpassengerfromseat/$uid',
      
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'turnId': tripId,
        'seatId': seatId
      })
    ).then ((response) {
      client.close();
      if(response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data["message"] != null){
          return APIResponse<Passenger>(error: true, errorMessage: data["message"]);
        } else {
          return APIResponse<Passenger>(data: Passenger.fromJson(data));
        }
      } 
      if(response.statusCode == 400) {
        final error = jsonDecode(response.body);
        return APIResponse<Passenger>(error: true, errorMessage: error['error']);
      }
      return APIResponse<Passenger>(error: true, errorMessage: 'An error occured');
    }).
    catchError((error) {
      client.close();
      return APIResponse<Passenger>(error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<List<BusTripData>>> getPastTurns(http.Client client, String uid, String loginToken) async {
    // get the current and upcoming active turns assigned to the conductor
    String url = Constants.SERVER;
    String token = loginToken;
    List<BusTripData> activeTurns = [];

    return client.get(
      '$url/getpastturns/$uid',
      
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    ).then ((response) {
      client.close();
      if(response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        for(var i=0; i<data["turns"].length;i++){
          activeTurns.add(BusTripData.fromJson(data["turns"][i]));
        }
        return APIResponse<List<BusTripData>>(data: activeTurns);
      } 
      if(response.statusCode == 400) {
        final error = jsonDecode(response.body);
        return APIResponse<List<BusTripData>>(error: true, errorMessage: error['error']);
      }
      return APIResponse<List<BusTripData>>(error: true, errorMessage: 'An error occured');
    }).
    catchError((error) {
      client.close();
      return APIResponse<List<BusTripData>>(error: true, errorMessage: 'An error occured');
    });
  }
  
}
