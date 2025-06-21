import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/common/widgets/button/basic_app_button.dart';
import 'package:ecommerce/data/auth/models/user_creation_req.dart';
import 'package:ecommerce/presentation/auth/pages/gender_and_age_selection.dart';
import 'package:ecommerce/presentation/auth/pages/siginin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // GlobalKey for form validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Form(
          key: _formKey, // Attach the form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _siginText(),
              const SizedBox(height: 20),
              _firstNameField(),
              const SizedBox(height: 20),
              _lastNameField(),
              const SizedBox(height: 20),
              _emailField(),
              const SizedBox(height: 20),
              _passwordField(context),
              const SizedBox(height: 20),
              _continueButton(context),
              const SizedBox(height: 20),
              _signin(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _siginText() {
    return const Text(
      'Create Account',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _firstNameField() {
    return TextFormField(
      controller: _firstNameCon,
      decoration: const InputDecoration(hintText: 'Firstname'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Firstname cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _lastNameField() {
    return TextFormField(
      controller: _lastNameCon,
      decoration: const InputDecoration(hintText: 'Lastname'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lastname cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailCon,
      decoration: const InputDecoration(hintText: 'Email Address'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email cannot be empty';
        }
        final emailPattern = r'\w+@\w+\.\w+';
        if (!RegExp(emailPattern).hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextFormField(
      controller: _passwordCon,
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Password'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password cannot be empty';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
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
            GenderAndAgeSelectionPage(
              userCreationReq: UserCreationReq(
                firstName: _firstNameCon.text,
                lastName: _lastNameCon.text,
                email: _emailCon.text,
                password: _passwordCon.text,
              ),
            ),
          );
        }
      },
      title: 'Continue',
    );
  }

  Widget _signin(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: "Do you have an account? "),
          TextSpan(
            text: 'Signin',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.pushReplacement(context, SigninPage());
              },
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
