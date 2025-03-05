import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wastemanagement/app/constants/theme_constant.dart';
import 'package:wastemanagement/app/di/di.dart';
import 'package:wastemanagement/features/auth/presentation/view/password_reset_view.dart';
import 'package:wastemanagement/features/auth/presentation/view/register_view.dart';

import '../../../home/presentation/view/home_view.dart';
import '../view_model/login/login_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _gap = const SizedBox(height: 8);

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
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/login.png', height: 250),
                            const SizedBox(height: 32),
                            const Text('Login to Your Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 24),
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
                              controller: _passwordController,
                              obscureText: !state.isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(state.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    context.read<LoginBloc>().add(TogglePasswordVisibilityEvent());
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Password is required';
                                if (value.length < 8) return 'Password must be at least 8 characters';
                                return null;
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    _gap,
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetView()));
                        },
                        child: const Text('Forgot Password?', style: TextStyle(color: Colors.blue, fontSize: 14)),
                      ),
                    ),
                    _gap,
                    ElevatedButton(
                      key: const ValueKey('loginButton'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          context.read<LoginBloc>().add(LoginUserEvent(email: email, password: password, context: context, destination: HomeView()));
                        }
                      },
                      child: const SizedBox(height: 50, child: Center(child: Text('Login', style: TextStyle(fontSize: 18)))),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Center the content
                      children: [
                        const Text('Don’t have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterView()));
                          },
                          child: const Text('Register', style: TextStyle(color: Colors.blue, fontSize: 14)),
                        ),
                      ],
                    ),

                    // Sign in with
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 32.0), child: Text('OR', style: TextStyle(fontSize: 16))),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () async {
                        final googleSignIn = GoogleSignIn(
                          serverClientId: "923200601436-7ici0ecq9joofqarmp4no04r2p66n5om.apps.googleusercontent.com",
                          clientId: "923200601436-7ici0ecq9joofqarmp4no04r2p66n5om.apps.googleusercontent.com",
                          scopes: ['email'],
                        );

                        googleSignIn.signIn().then((googleAccount) {
                          googleAccount!.authentication.then((googleAuthentication) {
                            final accessToken = googleAuthentication.accessToken;
                            final idToken = googleAuthentication.idToken;
                            final dio = getIt<Dio>();
                            dio.post('http://localhost:5000/auth/google', data: {'accessToken': accessToken, 'idToken': idToken}).then((response) {
                              print(response.data);
                            });
                          });
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: ThemeConstant.appBarColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/google-ic.png', height: 25, width: 25),
                            const SizedBox(width: 10),
                            Text('Sign in with Google'),
                          ],
                        ),
                      ),
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
