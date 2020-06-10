import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:transport_booking_system_conductor_mobile/controllers/auth_controller.dart';
import 'package:transport_booking_system_conductor_mobile/models/api_response.dart';
import 'package:transport_booking_system_conductor_mobile/models/user_data.dart';
import 'package:transport_booking_system_conductor_mobile/views/screens/home.dart';
import 'package:transport_booking_system_conductor_mobile/views/shared_widgets/page_widget.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthController _auth = AuthController();
  final _formKey = GlobalKey<FormState>();
  APIResponse<UserData> _apiResponse;
  String errorMessage = '';

  String email = '';
  String password ='';

  double screenHeight;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height; 
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            LowerHalf(),
            UpperHalf(),
            loginCard(context),
            PageTitleSignInPage()
          ],
        ),
      ),
    );
  }

  Widget loginCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      validator: (val) => isEmail(val) ?  null : 'Enter a valid email',
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: FlatButton(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 17.0),
                          ),
                          color: Colors.green[700],
                          textColor: Colors.white,
                          padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) { // validate the form based on the current state according to the conditions given in each TextFormField
                              setState(() {
                                _isLoading = true;
                              });
                              IOClient client = IOClient();
                              _apiResponse = await _auth.signInUser(client, email,password); // if form is valid sign in the user
                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                              setState(() {
                                _isLoading = false;
                              });
                              
                              if(_apiResponse.error){
                                setState(() {
                                  errorMessage = _apiResponse.errorMessage;
                                });
                                print(errorMessage);
                              } else {
                                setState(() {
                                  sharedPreferences.setString("token", _apiResponse.data.token); // cache user data
                                  sharedPreferences.setString("uid", _apiResponse.data.uid); 
                                });
                                String message = _apiResponse.data.message;
                                print (message);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home())); // navigate to the home page if the user correctly signs in
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text (
                      errorMessage,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.red[900],
                      ),
                    ),
                    // show the loading widget if the data is loading
                    _isLoading ? Center(child: LoadingWidget()) : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

