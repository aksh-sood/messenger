import 'package:flash_chat/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  Animation animationLogo;
  Animation animationColor;

  AnimationController controller;
  AnimationController color;
  int i = 0;
  @override
  void initState() {
    super.initState();
    color = AnimationController(vsync: this, duration: Duration(seconds: 2));
    animationColor =
        ColorTween(begin: Colors.blue, end: Colors.white).animate(color);
    controller = AnimationController(
      // upperBound:0.5,
      vsync: this,
      duration: Duration(seconds: 2, milliseconds: 500),
    );
    animationLogo =
        CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    controller.forward();
    color.forward();

    // animationLogo.addStatusListener((status) {
    //   if (status == AnimationStatus.completed && i < 2) {
    //     controller.reverse(from: 1);
    //     i++;
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //     i++;
    //   }
    // });

    color.addListener(() {
      setState(() {
        // print(animationColor.value);
      });
    });
    controller.addListener(() {
      setState(() {
        // print(animationLogo.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animationColor.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: "logo",
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: animationLogo.value * 100,
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    text: ['', 'Flash Chat'],
                    pause: const Duration(milliseconds: 1400),
                    speed: Duration(milliseconds: 45),
                    totalRepeatCount: 1,
                    repeatForever: false,
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              RoundedButton(buttonColor: Colors.lightBlueAccent , buttonText: 'Log In', buttonRoute: 'login'),
             RoundedButton(buttonColor: Colors.blueAccent, buttonText: 'Register', buttonRoute: 'registration'),
            ],
          ),
        ),
      ),
    );
  }
}
