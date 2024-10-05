import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/login_service.dart';
import 'home.dart';
import 'register_page.dart'; // Impor halaman Register (buat halaman ini jika belum ada)

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Sidebar(),
      appBar: AppBar(
        title: Text("LoginPage"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Column(
                        children: [
                          _emailTextField(),
                          SizedBox(
                            height: 20,
                          ),
                          _passwordTextField(),
                          SizedBox(
                            height: 40,
                          ),
                          _tombolLogin(),
                          SizedBox(
                            height: 20,
                          ),
                          _registerLink() // Tambahkan Link di sini
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Email"),
      controller: _emailCtrl,
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Password"),
      obscureText: true, // Menyembunyikan teks password
      controller: _passwordCtrl,
    );
  }

  Widget _tombolLogin() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        child: Text("Login"),
        onPressed: () async {
          String email = _emailCtrl.text;
          String password = _passwordCtrl.text;

          // Panggil API untuk login
          await LoginService().login(email, password).then(
            (response) async {
              // Periksa respons login dari server
              if (response.status == true) {
                // Jika login berhasil, simpan user ID dan token di SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setInt('userId', response.id);
                await prefs.setString('email', response.email);
                await prefs.setString('username', response.name);
                await prefs.setString('token', response.token);
                // print("User ID yang tersimpan: ${response.id}");

                // Pindah ke halaman utama
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              } else {}
            },
          ).catchError(
            (e) {
              // Tampilkan error jika terjadi kesalahan dalam pemanggilan API
              AlertDialog alertDialog = AlertDialog(
                content: Text("Error: Username atau password tidak valid"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  )
                ],
              );
              showDialog(context: context, builder: (context) => alertDialog);
            },
          );
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
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Aksi ketika teks "Register now!" diklik
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RegisterPage()), // Halaman registrasi
                );
              },
          ),
        ],
      ),
    );
  }
}

// .onError((LoginResponse e, stacktrace){
//             print("Error : ${e.status}");
//             AlertDialog alertDialog = AlertDialog(
//                 content: Text("Username atau password tidak valid"),
//                 actions: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text("Ok"),
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                   )
//                 ],
//               );
//               showDialog(context: context, builder: (context) => alertDialog);
//           })