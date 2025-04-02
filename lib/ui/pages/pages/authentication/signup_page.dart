import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/responsive_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find();
    return ResponsiveContainer(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        key: const Key('signUpScaffold'),
        body: _buildSignUpForm(controller),
      ),
    );
  }

  Widget _buildSignUpForm(AuthController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Create User",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  key: const Key('signUpEmail'),
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter email";
                    } else if (!value.contains('@')) {
                      return "Enter valid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  key: const Key('signUpPassword'),
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter password";
                    } else if (value.length < 6) {
                      return "Password should have at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    key: const Key('signUpSubmit'),
                    child: const Text("Submit"),
                    onPressed: () async {
                      // Dismiss the keyboard
                      FocusScope.of(context).unfocus();
                      final form = _formKey.currentState;
                      form!.save();
                      if (form.validate()) {
                        try {
                          await controller.signup(
                              _emailController.text, _passwordController.text);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error $e')),
                          );
                        }

                        Get.back();
                      }
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
