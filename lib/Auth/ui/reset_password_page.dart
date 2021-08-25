import 'package:firebase_gsg/Auth/providers/auth_provider.dart';
import 'package:firebase_gsg/Auth/ui/widgets/custom_textField.dart';
import 'package:firebase_gsg/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatelessWidget {
  static final routeName = 'reset';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, x) {
          return Column(
            children: [
              CustomTextfield('Email', provider.emailController),
              CustomButton(provider.resetPassword, 'Reset Password'),
            ],
          );
        },
      ),
    );
  }
}
