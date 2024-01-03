import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/auth/auth_service.dart';
import 'package:tubes_ppb/style/color.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    bool isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: lightBlue,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  flex: isKeyboardVisible ? 2 : 4,
                  child: Container(
                    width: mediaQuery.size.width,
                    color: lightBlue,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Register",
                        ),
                        Text(
                          "Create your account to get your best shoes!",
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.only(top: 70),
                    width: mediaQuery.size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            topRight: Radius.circular(70))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: mediaQuery.size.width / 1.2,
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'Tulis username disini',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: gray), // Atur warna border
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                            ),
                            // style: text_14_500,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          width: mediaQuery.size.width / 1.2,
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Tulis email disini',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: gray), // Atur warna border
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                            ),
                            // style: text_14_500,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          width: mediaQuery.size.width / 1.2,
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !isVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Tulis password disini',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: gray), // Atur warna border
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: FaIcon(
                                    isVisible
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 18,
                                  )),
                            ),
                            // style: text_14_500,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () async {
                            final message = await AuthService().register(
                              username: _usernameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            if (message == 'Registration Success') {
                              // Navigasi ke halaman setelah registrasi berhasil
                              Navigator.of(context)
                                  .pop(); // Kembali ke halaman login setelah registrasi berhasil
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message ?? 'An error occurred'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 45,
                            width: mediaQuery.size.width / 1.2,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Center(
                                child: Text(
                              "Register",
                              // style: text_14_600_white,
                            )),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                // style: text_12_300,
                              ),
                              Text(
                                'Sign-in',
                                // style: text_12_500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
