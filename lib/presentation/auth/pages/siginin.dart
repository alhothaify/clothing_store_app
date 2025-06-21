import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/common/widgets/button/basic_app_button.dart';
import 'package:ecommerce/data/auth/models/user_signin_req.dart';
import 'package:ecommerce/presentation/auth/pages/enter_password.dart';
import 'package:ecommerce/presentation/auth/pages/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add GlobalKey

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(hideBack: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Attach GlobalKey to Form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _siginText(context),
                const SizedBox(height: 20),
                _emailField(context),
                const SizedBox(height: 20),
                _continueButton(context),
                const SizedBox(height: 20),
                _createAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _siginText(BuildContext context) {
    return const Text(
      'Sign in',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextFormField(
      controller: _emailCon,
      decoration: const InputDecoration(hintText: 'Enter Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email cannot be empty';
        }
        // Add a simple email pattern validation
        final emailPattern = r'\w+@\w+\.\w+';
        if (!RegExp(emailPattern).hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          // Proceed if the form is valid
          AppNavigator.push(
            context,
            EnterPasswordPage(
              signinReq: UserSigninReq(
                email: _emailCon.text,
              ),
            ),
          );
        }
      },
      title: 'Continue',
    );
  }

  Widget _createAccount(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: "Don't you have an account? "),
          TextSpan(
            text: 'Create one',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.push(context, SignupPage());
              },
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
