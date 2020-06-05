import 'package:flutter/material.dart';

class UpperHalf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight / 2,
      child: Image(
        image: AssetImage('assets/road9.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }
}

class LowerHalf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight / 2,
        color: Color(0xFFECF0F3),
      ),
    );
  }
}

class PageUpperHalf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight / 2,
    );
  }
}

class PageLowerHalf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight / 2,
        child: Image.asset(
          'assets/road9.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PageTitleSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Image(image: AssetImage('assets/logo.png')),
      ),
    );
  }
}

class PageTitleHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(image: AssetImage('assets/logo.png')),
    );
  }
}