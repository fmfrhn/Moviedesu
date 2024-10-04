// import 'package:dio/dio.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moviedesu/ui/login_page.dart';
import '../service/login_service.dart';
// import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Sidebar(),
      appBar: AppBar(
        title: Text("Register Page"),
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
                          _nameTextField(),
                          SizedBox(
                            height: 20,
                          ),
                          _passwordTextField(),
                          SizedBox(
                            height: 40,
                          ),
                          _tombolRegister(),
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

  Widget _nameTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Name"),
      controller: _nameCtrl,
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Password"),
      obscureText: true, // Menyembunyikan teks password
      controller: _passwordCtrl,
    );
  }

  Widget _tombolRegister() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        child: Text("Registrasi"),
        onPressed: () async {
          String email = _emailCtrl.text;
          String name = _nameCtrl.text;
          String password = _passwordCtrl.text;
          await LoginService().register(email, name, password).then((response) {
            if (response.status == true) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LoginPage()));
            } else {
              AlertDialog alertDialog = AlertDialog(
                content: Text("Username atau password tidak valid"),
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
            }
          });
        },
      ),
    );
  }

}
