import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/my_utils.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/email_text_field.dart';
import 'package:flash_chat/components/password_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String userName = '';
  bool showSpinner = false;
  bool hidePassword = true;
  IconData passwordButtonIcon = Icons.visibility;
  TextEditingController passwordTextFieldController = TextEditingController();
  TextEditingController emailTextFieldController = TextEditingController();
  bool isRegisterButtonEnable = false;
  List<Widget> credentialUserWarningList = [const SizedBox()];

  void passwordTextFieldCleaner() {
    password = '';
    passwordTextFieldController.clear();
    registerButtonEnableChecker();
  }

  void registerButtonEnableChecker() {
    isRegisterButtonEnable =
        (password.length > 5 && email != '') ? true : false;
  }

  void tryToRegister() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      passwordTextFieldCleaner();
      MyUtils.passwordWarning(
          password: password,
          credentialUserWarningList: credentialUserWarningList);
      Navigator.pushNamed(context, ChatScreen.id);
      setState(() {
        showSpinner = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        showSpinner = false;
      });
      passwordTextFieldCleaner();
      MyUtils.fireAuthErrorHandling(
          credentialUserWarningList: credentialUserWarningList, error: e);
      // ignore: avoid_print
      print(e);
    }
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
              EmailTextField(
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
              PasswordTextField(
                obscureText: hidePassword,
                textEditingController: passwordTextFieldController,
                onSubmitted: (value) => tryToRegister(),
                onChanged: (value) {
                  password = value;
                  if (value.isEmpty) {
                    setState(() {
                      hidePassword = true;
                    });
                  }
                  registerButtonEnableChecker();
                  setState(() {
                    MyUtils.passwordWarning(
                        password: password,
                        credentialUserWarningList: credentialUserWarningList);
                  });
                },
                suffixIconButton: (passwordTextFieldController.text.isNotEmpty)
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                child: Row(
                  children: credentialUserWarningList,
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
                        tryToRegister();
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
