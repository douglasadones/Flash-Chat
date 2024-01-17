import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flash_chat/screens/chat_screen.dart';

import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/rounded_button.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  late String password;
  // Código repetido abaixo:
  bool showSpinner = false;
  bool hidePassword = true;
  TextEditingController emailTextFieldController = TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();
  IconData passwordButtonIcon = Icons.visibility;
  int passwordlength = 0;
  IconData passwordWarningIcon = Icons.check_box_outline_blank_rounded;
  bool isLoginButtonEnable = false;
  List<Widget> passwordWarningList = [const SizedBox()];

  void passWordLengthWarning() {
    Widget passwordWarning;
    if (passwordlength > 0 && passwordlength < 6) {
      passwordWarning = const Text(
        'At least 6 characters',
        style: kPasswordLessThansixCharacters,
      );
      passwordWarningList.clear();
      passwordWarningList.add(passwordWarning);
      passwordWarningList.add(
        const Icon(
          Icons.close_rounded,
          color: Colors.red,
        ),
      );
    } else if (passwordlength > 5) {
      passwordWarning = const Text(
        'At least 6 characters',
        style: kPasswordEqualOrgreaterThansixCharacters,
      );
      passwordWarningList.clear();
      passwordWarningList.add(passwordWarning);
      passwordWarningList.add(
        const Icon(
          Icons.check,
          color: Colors.green,
        ),
      );
    } else {
      passwordWarningList.clear();
      passwordWarningList.add(const SizedBox());
    }
  }

  void loginButtonEnableChecker() {
    isLoginButtonEnable = (passwordlength > 5 && email != '') ? true : false;
  }

  void goToChatScreenThroughLoginScreenMethod() async {
    if (isLoginButtonEnable) {
      setState(() {
        showSpinner = true;
      });
      try {
        final isUserRegistered = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        password = '';
        passwordlength = 0;
        passWordLengthWarning();
        Navigator.pushNamed(context, ChatScreen.id);
              setState(() {
          showSpinner = false;
        });
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        // ignore: avoid_print
        print(e);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                textInputAction:
                    TextInputAction.next, // Moves focus to next TextField.
                controller: emailTextFieldController,
                cursorColor: Colors.blueAccent,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    email = value;
                    loginButtonEnableChecker();
                  });
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                  suffixIcon: (emailTextFieldController.text.isNotEmpty)
                      ? IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            setState(() {
                              emailTextFieldController.clear();
                            });
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: passwordTextFieldController,
                onSubmitted: (value) {
                  goToChatScreenThroughLoginScreenMethod();
                },
                onChanged: (value) {
                  password = value;
                  passwordlength = value.length;
                  if (value.isEmpty) {
                    setState(() {
                      hidePassword = true;
                    });
                  }
                  loginButtonEnableChecker();
                  setState(() {
                    passWordLengthWarning();
                  });
                },
                cursorColor: Colors.blueAccent,
                keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.center,
                obscureText: hidePassword,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                  suffixIcon: (passwordTextFieldController.text.isNotEmpty)
                      ? GestureDetector(
                          child: Icon(
                            hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey.shade600,
                          ),
                          onTap: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        )
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                child: Row(
                  children: passwordWarningList, // repetido
                ),
              ),
              const SizedBox(
                height: 17.0,
              ),
              RoundedButton(
                elevation: (isLoginButtonEnable) ? 5.0 : 0,
                color: (isLoginButtonEnable) ? Colors.blueAccent : Colors.grey,
                label: 'Log In',
                onPressed: (isLoginButtonEnable)
                    ? () async {
                        goToChatScreenThroughLoginScreenMethod();
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
