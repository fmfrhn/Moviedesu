import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/login_service.dart';
import 'home.dart';
import 'register_page.dart';
import 'package:moviedesu/widget/app_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        // Menempatkan body di tengah layar
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              width: double.infinity,
              constraints: BoxConstraints(
                  // maxWidth: 400, // Menentukan lebar maksimum Container
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/moviedesu-nobg.png',
                    height: 250, // Mengurangi ukuran logo
                  ),
                  SizedBox(height: 20), // Mengurangi jarak antara logo dan form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _emailTextField(),
                        SizedBox(height: 15), // Mengurangi jarak antar field
                        _passwordTextField(),
                        SizedBox(
                            height:
                                30), // Mengurangi jarak antara form dan tombol login
                        _tombolLogin(),
                        SizedBox(
                            height:
                                15), // Mengurangi jarak antara tombol login dan link register
                        _registerLink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      controller: _emailCtrl,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle:
            TextStyle(color: Colors.purple), // Ganti warna label menjadi ungu
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      controller: _passwordCtrl,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle:
            TextStyle(color: Colors.purple), // Ganti warna label menjadi ungu
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _tombolLogin() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.purple[150], // Ganti warna tombol login menjadi ungu
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text("Login", style: TextStyle(fontSize: 16)),
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            String email = _emailCtrl.text;
            String password = _passwordCtrl.text;

            // Panggil API untuk login
            await LoginService().login(email, password).then(
              (response) async {
                if (response.status == true) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setInt('userId', response.id);
                  await prefs.setString('email', response.email);
                  await prefs.setString('username', response.name);
                  // await prefs.setString('token', response.token);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                }
              },
            ).catchError(
              (e) {
                print('Login Error: $e'); // Log error jika login gagal
                AlertDialog alertDialog = AlertDialog(
                  content: Text("Error: Username atau password tidak valid"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .purple), // Ganti warna tombol alert menjadi ungu
                    ),
                  ],
                );
                showDialog(context: context, builder: (context) => alertDialog);
              },
            );
          }
        },
      ),
    );
  }

  Widget _registerLink() {
    return RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style: TextStyle(color: Colors.black),
        children: <TextSpan>[
          TextSpan(
            text: 'Register now!',
            style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold), // Ganti warna teks menjadi ungu
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
          ),
        ],
      ),
    );
  }
}
