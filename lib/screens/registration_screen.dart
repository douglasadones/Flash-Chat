import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  late String password;
  bool showSpinner = false;
  bool hidePassword = true;
  IconData passwordButtonIcon = Icons.visibility;
  TextEditingController passwordTextFieldController = TextEditingController();
  TextEditingController emailTextFieldController = TextEditingController();
  int passwordlength = 0;
  IconData passwordWarningIcon = Icons.check_box_outline_blank_rounded;
  bool isRegisterButtonEnable = false;
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

  void registerButtonEnableChecker() {
    isRegisterButtonEnable = (passwordlength > 5 && email != '') ? true : false;
  }

  void goToChatScreenThroughRegistrationScreenMethod() async {
    if (isRegisterButtonEnable) {
      setState(() {
        showSpinner = true;
      });
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        password = '';
        passwordlength = 0;
        passWordLengthWarning();
        Navigator.pushNamed(context, ChatScreen.id);
              passwordTextFieldController.clear();
        setState(() {
          showSpinner = false;
        });
      } catch (e) {
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
              LoginTextField(
                textEditingController: emailTextFieldController,
                onChanged: (value) {
                  setState(() {
                    email = value;
                    registerButtonEnableChecker();
                  });
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                onSubmitted: (value) =>
                    goToChatScreenThroughRegistrationScreenMethod(),
                controller: passwordTextFieldController,
                onChanged: (value) {
                  password = value;
                  passwordlength = value.length;
                  if (value.isEmpty) {
                    setState(() {
                      hidePassword = true;
                    });
                  }
                  registerButtonEnableChecker();
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
                            (hidePassword)
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
                  children: passwordWarningList,
                ),
              ),
              const SizedBox(
                height: 17.0,
              ),
              RoundedButton(
                elevation: (isRegisterButtonEnable) ? 5.0 : 0,
                color:
                    (isRegisterButtonEnable) ? Colors.blueAccent : Colors.grey,
                label: 'Register',
                onPressed: (isRegisterButtonEnable)
                    ? () async {
                        goToChatScreenThroughRegistrationScreenMethod();
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
