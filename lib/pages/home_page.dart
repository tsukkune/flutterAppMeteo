import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_meteo/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';


import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_app_meteo/models/weather.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isEmailVerified = false;
  String weatherUrl = 'https://api.apixu.com/v1/forecast.json?key=6fc55b4061b1483db2e80607191104&q=Bordeaux&days=7&lang=fr';
  Weather currentWeather;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();

  }

  Future<Weather> getWeather() async {
    try{
      final call = await _remote(weatherUrl);
      final rs = json.decode(utf8.decode(call.bodyBytes));
//      final weather = rs.map((e) => Weather.from(e));
      final weather = Weather.from(rs);
      return weather;
    }catch(e){
      print(e);
    }
  }

  Future<http.Response> _remote(String uri) async {
    return http.get(
      uri
    );
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text(
              "Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter App Meteo'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
        body: Container(padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: <Widget>[
                FutureBuilder<Weather>(
                  future: getWeather(),
                  builder:(context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done)
                    {
                      return Column(
                        children: <Widget>[
                          Text('city : ${snapshot.data.city}'),
                          Text('date : ${snapshot.data.date}'),
                          Text('condition : ${snapshot.data.condition}'),
                          Text('temp : ${snapshot.data.temp}'),
                          Text('min : ${snapshot.data.min}'),
                          Text('max : ${snapshot.data.max}'),
                          Text('ressenti : ${snapshot.data.feelTemp}'),
                          Text('humidite : ${snapshot.data.humidity}'),
                          Text('vitesse vent : ${snapshot.data.wind}'),
                          Text('visibilite : ${snapshot.data.visibility}'),
                          Text('indice UV : ${snapshot.data.uv}'),

                        ]
                      );
                    }
                      //return Text('condition : ${snapshot.data.condition}');
                    else
                      return CircularProgressIndicator();
                  }
                  ,
                ),
                Expanded(
                  child: FlareActor("assets/Eolienne2.flr",
                    alignment: Alignment.center,
                    fit:BoxFit.contain,
                    animation:"eolienne2",
                    isPaused: false,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

