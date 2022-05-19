import 'package:absensi/bottom_navbar.dart';
import 'package:absensi/page/sign_up_page.dart';
import 'package:absensi/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerNip = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _isHidePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const BottomNavbar(),
          ),
          (route) => false,
        );
      });
    }
    super.initState();
  }

  Widget header() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        child: Column(
          children: [
            Image.asset("assets/sul-sel.png"),
            const Text("Dinas Pendidikan"),
            const Text("Provinsi Sulawesi Selatan"),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                header(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controllerNip,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.account_circle_rounded),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            labelText: "NIP"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Masukkan NIP";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _controllerPassword,
                        obscureText: _isHidePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            labelText: "Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _togglePasswordVisibility();
                              },
                              child: Icon(
                                  _isHidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _isHidePassword
                                      ? Colors.grey
                                      : Colors.blue),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Masukkan Password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(24)))),
                          onPressed: () async {
                            String _email = "${_controllerNip.text}@gmail.com";

                            if (_formKey.currentState!.validate()) {
                              context.read<AuthService>().login(
                                    email: _email,
                                    password: _controllerPassword.text,
                                  );

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavbar()),
                                  (route) => false);
                            }
                          },
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      buttonSignUp()
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget buttonSignUp() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white38),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)))),
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpPage()));
        },
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: const Text(
            "SIGN UP",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),
          ),
        ));
  }
}
