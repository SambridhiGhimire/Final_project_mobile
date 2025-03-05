import 'package:flutter/material.dart';

import '../../../../app/di/di.dart';
import '../../../../core/common/snackbar/snackbar.dart';
import '../../domain/use_case/sign_up_user.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _gap = const SizedBox(height: 8);

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/login.png', height: 300),
                        const SizedBox(height: 32),
                        const Text('Create Your Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 24),
                        TextFormField(
                          key: const ValueKey('name'),
                          controller: _nameController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('email'),
                          controller: _emailController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid email address';
                            }
                            // Regex for validating email format
                            final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('password'),
                          obscureText: _isObscure,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _isObscure = !_isObscure),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    _gap,
                    _gap,
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          final name = _nameController.text.trim();

                          final signUp = getIt<SignUpUser>();
                          final res = await signUp(SignUpUserParams(email: email, password: password, name: name));

                          res.fold((error) => showMySnackBar(context: context, message: error.message, color: Color(0xFF9B6763)), (success) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success)));
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const SizedBox(height: 50, child: Center(child: Text('Sign Up', style: TextStyle(fontSize: 18)))),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Center the content
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Login', style: TextStyle(color: Colors.blue, fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
