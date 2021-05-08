import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email,password;
  bool spinner=false;
  final _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      progressIndicator:SpinKitFadingCircle(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Color(0xFFd9c811) : Colors.blue,
            ),
          );
        },
      ) ,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email=value;
                },
                style: TextStyle(color: Colors.blue),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter the email',
                ),
                keyboardType: TextInputType.emailAddress,
                // controller: ,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password=value;
                },
                style: TextStyle(color: Colors.blue),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter the password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonColor: Colors.lightBlueAccent,
                buttonText: 'Log In',
                onpressed: () async{
                        setState(() {
                          spinner=true;
                        });
                  final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
                  try{

                    if(user!=null) {
                    Navigator.pushNamed(context, 'chat');
                    setState(() {
                      spinner=false;
                    });
                  }}catch(e){
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
