import 'package:flash_chat/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email, password;
  bool spinning=false;
  final _auth= FirebaseAuth.instance;
  User loggedInUser;



  void getCurrentUser()async{
    try{
    final user=await _auth.currentUser;
    if(user!=null){
      loggedInUser= user;
      print(loggedInUser.email);
    }}catch(e){
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
getCurrentUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall:spinning ,
        child: Padding(
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
                  //Do something with the user inp
                  email = value;
                },

                style: TextStyle(color: Colors.blue),
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter your email"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                style: TextStyle(color: Colors.blue),
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonText: 'Register',
                buttonColor: Colors.blueAccent,
                onpressed: () async{
                  setState(() {
                    spinning=true;
                  });

                  try {
             final newUser= await  _auth.createUserWithEmailAndPassword(email: email, password: password);

                  if(newUser!=null){
                    Navigator.pushNamed(context, 'chat');
                  }
                  setState(() {
                    spinning=false;
                  });
                  }catch(e){
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
