import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moviedesu/ui/login_page.dart';
import 'package:moviedesu/widget/app_bar.dart';
import '../service/login_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

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
                    offset: Offset(0, 3), // perubahan posisi bayangan
                  ),
                ],
              ),
              width: double.infinity,
              constraints: BoxConstraints(
                  // maxWidth: 400, // Menentukan lebar maksimum Container
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Menempatkan konten secara vertikal di tengah
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Menempatkan konten secara horizontal di tengah
                children: [
                  // Text(
                  //   "Register",
                  //   style: TextStyle(
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.purple, // Ganti warna teks menjadi ungu
                  //   ),
                  // ),
                  Image.asset(
                    'assets/moviedesu-nobg.png',
                    height: 250,
                  ),
                  // SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _emailTextField(),
                        SizedBox(height: 20),
                        _nameTextField(),
                        SizedBox(height: 20),
                        _passwordTextField(),
                        SizedBox(height: 40),
                        _tombolRegister(),
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

  Widget _nameTextField() {
    return TextFormField(
      controller: _nameCtrl,
      decoration: InputDecoration(
        labelText: "Name",
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
          return 'Please enter your name';
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

  Widget _tombolRegister() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.purple[150], // Ganti warna tombol menjadi ungu
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text("Register", style: TextStyle(fontSize: 16)),
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            String email = _emailCtrl.text;
            String name = _nameCtrl.text;
            String password = _passwordCtrl.text;

            // Panggil API untuk registrasi
            await LoginService().register(email, name, password).then(
              (response) {
                if (response.status == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
            ).catchError((e) {
              AlertDialog alertDialog = AlertDialog(
                content: Text("Email tidak valid!"),
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
            });
          }
        },
      ),
    );
  }
}
