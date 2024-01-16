import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jkblog/blocs/auth_bloc/auth_bloc.dart';
import 'package:jkblog/widgets/widget.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPswdNotShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
          if (state is AuthFailure) {
            showSnackBar(context, Colors.red, state.error);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 70,
                bottom: 40,
              ),
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/logo.png',
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Login to your Account',
                          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: emailController,
                        key: emailFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Email',
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.deepOrange,
                            width: 2,
                          )),
                          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Email can not be empty';
                          } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)) {
                            return "Please enter a valid email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: passwordFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: isPswdNotShow,
                        controller: passwordController,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Password',
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.deepOrange,
                              width: 2,
                            )),
                            labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                context.read<AuthBloc>().add(ShowPassword(isPassShowed: isPswdNotShow));
                              },
                              child: Icon(
                                Icons.remove_red_eye_rounded,
                                color: isPswdNotShow == true ? Colors.grey : Theme.of(context).primaryColor,
                              ),
                            )),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Password can not be empty";
                          } else if (val.length < 8) {
                            return 'Password must have atleast 8 characters';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 25),
                      InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthLoginRequested(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ));
                          }
                        },
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthSLoading) {
                              return Container(
                                height: 45,
                                width: 200,
                                alignment: Alignment.center,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              );
                            }
                            return Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.deepOrange, Color.fromARGB(255, 246, 158, 132)], // Define your gradient colors
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(8.0), // Match the button's shape
                              ),
                              height: 45,
                              width: 200,
                              alignment: Alignment.center,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(color: Colors.white, fontSize: 16.0),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Forgot the password?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            context.read<AuthBloc>().add(AuthGoogleRegisterRequested());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                'images/google_logo.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't Have an Account?",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false);
                            },
                            child: Text('Register here',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                )),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}