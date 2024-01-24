import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flash_chat/screens/chat_screen.dart';

import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/email_text_field.dart';
import 'package:flash_chat/components/password_text_field.dart';
import 'package:flash_chat/components/my_utils.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  List<Widget> credentialUserWarningList = [const SizedBox()];
  String email = '';
  String password = '';
  bool showSpinner = false;
  bool hidePassword = true;
  TextEditingController emailTextFieldController = TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();
  IconData passwordButtonIcon = Icons.visibility;
  bool isLoginButtonEnable = false;

  void loginButtonEnableChecker() {
    isLoginButtonEnable = (password.length > 5 && email != '') ? true : false;
  }

  void passwordTextFieldCleaner() {
    setState(() {
      hidePassword = true;
    });
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
      MyUtils.passwordErrorHandlingAndUpdateUIWarning(
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
      MyUtils.fireAuthErrorHandlingAndUpdateUIWarning(
          error: e, credentialUserWarningList: credentialUserWarningList);
      loginButtonEnableChecker();
      // ignore: avoid_print
      print(e);
    }
  }

  void trySendResetPasswordEmail() async {
    if (email != '') {
      try {
        final isEmailAlreadyInUse = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: 'password',
        );
        isEmailAlreadyInUse.user!.delete();
        Navigator.of(context).pop();
        setState(() {
          credentialUserWarningList.clear();
          credentialUserWarningList.add(const Text(
            'Email Not Found',
            style: kPasswordLessThansixCharacters,
          ));
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          MyUtils.fireAuthErrorHandlingAndUpdateUIWarning(
              credentialUserWarningList: credentialUserWarningList, error: e);
        } else {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          Navigator.of(context).pop();
          emailSentAlertPopUp(context);
        }
      }
    } else {
      Navigator.pop(context);
      setState(() {
        credentialUserWarningList.clear();
        credentialUserWarningList.add(const Text(
          'Email Not Found',
          style: kPasswordLessThansixCharacters,
        ));
      });
    }
  }

  Future _forgotPasswordBox(BuildContext context) {
    return showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        contentPadding: const EdgeInsets.only(left: 23.0, bottom: 10.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Forgot your password?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w500),
            ),
            Flexible(
              child: IconButton(
                alignment: Alignment.center,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
        content: const Text('Enter your registered email:'),
        actions: [
          SizedBox(
            width: double.maxFinite,
            child: TextField(
              cursorColor: Colors.blueAccent,
              decoration: kforgotPasswordTextFieldDecoration.copyWith(
                hintText: 'Enter your email',
              ),
              onChanged: (value) {
                email = value;
              },
              onSubmitted: (value) => trySendResetPasswordEmail(),
            ),
          ),
          Center(
            child: RoundedButton(
              color: Colors.blueAccent,
              label: 'Send',
              onPressed: () => trySendResetPasswordEmail(),
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
    );
  }

  Future<void> emailSentAlertPopUp(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: const Text(
            'Password reset email sent',
            textAlign: TextAlign.center,
          ),
          content: const Text(
              'We\'ve just sent you an email with instructions '
              'on how to reset your password. Please check your '
              'inbox and follow the provided link to complete the '
              'password reset process. If you don\'t see the email '
              'in your inbox, please check your spam or junk folder.',
              textAlign: TextAlign.justify),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.blueAccent, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                    MyUtils.passwordErrorHandlingAndUpdateUIWarning(
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
                  horizontal: 5,
                  vertical: 6,
                ),
                child: Row(
                  children: credentialUserWarningList, // repetido
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const Expanded(child: SizedBox()),
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    onTap: () {
                      email = '';
                      _forgotPasswordBox(context);
                    },
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: RoundedButton(
                  elevation: (isLoginButtonEnable) ? 5.0 : 0,
                  color:
                      (isLoginButtonEnable) ? Colors.blueAccent : Colors.grey,
                  label: 'Log In',
                  onPressed: (isLoginButtonEnable)
                      ? () async {
                          tryingToSingnInMethod();
                          passwordTextFieldCleaner();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
