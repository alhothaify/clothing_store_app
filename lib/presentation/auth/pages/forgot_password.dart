import 'package:ecommerce/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/common/widgets/button/basic_reactive_button.dart';
import 'package:ecommerce/domain/auth/usecases/send_password_reset_email.dart';
import 'package:ecommerce/presentation/auth/pages/password_reset_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/button/button_state.dart';


class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add form key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }

            if (state is ButtonSuccessState) {
              AppNavigator.push(context, const PasswordResetEmailPage());
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Form(
              key: _formKey, // Attach form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _siginText(),
                  const SizedBox(height: 20),
                  _emailField(),
                  const SizedBox(height: 20),
                  _continueButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _siginText() {
    return const Text(
      'Forgot Password',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailCon,
      decoration: const InputDecoration(hintText: 'Enter Email'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email cannot be empty';
        }
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _continueButton() {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              context.read<ButtonStateCubit>().execute(
                usecase: SendPasswordResetEmailUseCase(),
                params: _emailCon.text,
              );
            }
          },
          title: 'Continue',
        );
      },
    );
  }
}
