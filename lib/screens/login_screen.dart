import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flash_chat/screens/chat_screen.dart';

import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/email_text_field.dart';
import 'package:flash_chat/components/password_text_field.dart';
import 'package:flash_chat/components/my_utils.dart';

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
  String password = '';
  // Código repetido abaixo:
  bool showSpinner = false;
  bool hidePassword = true;
  TextEditingController emailTextFieldController = TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();
  IconData passwordButtonIcon = Icons.visibility;
  bool isLoginButtonEnable = false;
  List<Widget> credentialUserWarningList = [const SizedBox()];

  void loginButtonEnableChecker() {
    isLoginButtonEnable = (password.length > 5 && email != '') ? true : false;
  }

  void passwordTextFieldCleaner() {
    password = '';
    passwordTextFieldController.clear();
  }

  void tryingToSingnInMethod() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final isUserRegistered = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      MyUtils.passwordWarning(
          password: password,
          credentialUserWarningList: credentialUserWarningList);
      Navigator.pushNamed(context, ChatScreen.id);
      setState(() {
        showSpinner = false;
      });
      loginButtonEnableChecker();
    } on FirebaseAuthException catch (e) {
      setState(() {
        showSpinner = false;
      });
      MyUtils.fireAuthErrorHandling(
          error: e, credentialUserWarningList: credentialUserWarningList);
      loginButtonEnableChecker();
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
                    loginButtonEnableChecker();
                  });
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              PasswordTextField(
                textEditingController: passwordTextFieldController,
                obscureText: hidePassword,
                onSubmitted: (value) {
                  tryingToSingnInMethod();
                  passwordTextFieldCleaner();
                },
                onChanged: (value) {
                  password = value;
                  if (value.isEmpty) {
                    setState(() {
                      hidePassword = true;
                    });
                  }
                  setState(() {
                    MyUtils.passwordWarning(
                        password: password,
                        credentialUserWarningList: credentialUserWarningList);
                    loginButtonEnableChecker();
                  });
                },
                suffixIconButton: (passwordTextFieldController.text.isNotEmpty)
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                child: Row(
                  children: credentialUserWarningList, // repetido
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
                        tryingToSingnInMethod();
                        passwordTextFieldCleaner();
                      }
                    : null,
              ),
              RoundedButton(
                color: Color.fromARGB(255, 37, 128, 131),
                label: 'teste \'esqueceu a senha\'',
                onPressed: () async {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email);
                  // ignore: avoid_print
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
