import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/services/auth.dart';
import 'package:instagram_clone/shared/constants.dart';
import 'package:instagram_clone/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function switchView;
  SignIn({this.switchView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthenticationService _authService = AuthenticationService();

  final List<String> languages = ["English (United States)", "Hindi"];

  String email = "";
  String password = "";

  bool _obscureText = true;
  bool _isButtonEnabled = false;
  bool isLoading = false;

  isEnabled() {
    setState(() {
      if (email.isNotEmpty && password.isNotEmpty) {
        _isButtonEnabled = true;
      }
      else {
        _isButtonEnabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var _pageSize = MediaQuery.of(context).size.height;
    var _notifySize = MediaQuery.of(context).padding.top;
    var _appBarSize = 0;
    // var _appBarSize = appBar.preferredSize.height;

    return SafeArea(
      child: Scaffold(
        body: isLoading ? Loading() : SingleChildScrollView(
          child: Container(
            height: _pageSize - (_notifySize + _appBarSize),
            color: Colors.white,
            child: Column(
              children: [
                languageSelection(),
                Expanded(child: Container()),
                instaText(),
                emailField(),
                passwordField(),
                loginButton(),
                getHelpText(),
                orPartition(),
                loginWithFacebook(),
                Expanded(child: Container()),
                bottomSignUpBanner(),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Container emailField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      height: 60.0,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Email",
        ),
        onChanged: (val) {
          setState(() {
            email = val.toString();
            isEnabled();
          });
        },
      ),
    );
  }

  Container passwordField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      height: 60.0,
      child: TextFormField(
        obscureText: _obscureText,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Password",
            suffixIcon: GestureDetector(
              child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              onTap: () {
                setState(() => _obscureText = !_obscureText);
              },
            )
        ),
        onChanged: (val) {
          setState(() {
            password = val.toString();
            isEnabled();
          });
        },
      ),
    );
  }

  Container loginButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      height: 75.0,
      width: double.infinity,
      child: FlatButton(
        child: Text(
          "Log In",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        color: Colors.blue,
        disabledColor: Colors.blue[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        onPressed: _isButtonEnabled
            ? () async {
          setState(() {
            print("$email $password");
            isLoading = true;
          });
          dynamic result = await _authService.signInWithEmailAndPassword(email, password);
          if (result == null) {
            setState(() {
              print("Error Logging In");
              isLoading = false;
            });
          }
        }
            : null,
      ),
    );
  }

  Container getHelpText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
                text: "Forgot your login details? ",
                style: TextStyle(color: Colors.grey),
                recognizer: TapGestureRecognizer()..onTap = () {
                  print("Go get Help");
                }
            ),
            TextSpan(
                text: "Get help logging in.",
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {
                  print("Go get Help");
                }
            ),
          ]
        ),
      ),
    );
  }

  Container orPartition() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        children: [
          Expanded(child: Divider(endIndent: 15.0, thickness: 1.0)),
          Text(
            "OR",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Divider(indent: 15.0, thickness: 1.0)),
        ],
      ),
    );
  }

  Container loginWithFacebook() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(AssetImage("assets/images/fb_logo.png")),
            Text("  Log In with facebook")
          ],
        ),
        onPressed: () {
          print("Log In with facebook");
        },
      ),
    );
  }

  Container bottomSignUpBanner() {
    return Container(
      child: Column(
        children: [
          Divider(thickness: 2.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
            child: Container(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.grey),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        setState(() {
                          widget.switchView();
                        });
                      }
                    ),
                    TextSpan(
                      text: "Sign up.",
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        setState(() {
                          widget.switchView();
                        });
                      }
                    ),
                  ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
