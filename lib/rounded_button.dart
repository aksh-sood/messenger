import 'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {
 final Color buttonColor;
  final String buttonRoute,buttonText;
  RoundedButton({@required this.buttonColor,@required this.buttonText,@required this.buttonRoute});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () {
            //Go to registration screen.
            Navigator.pushNamed(context, buttonRoute);
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonText,
          ),
        ),
      ),
    );
  }
}
