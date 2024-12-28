import 'package:flutter/material.dart';
import 'package:moviedesu/ui/home.dart';
import 'package:moviedesu/ui/login_page.dart';
import 'package:moviedesu/ui/watchlist_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    _getUserId(); // Panggil fungsi ini saat widget diinisialisasi
  }

  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
      email = prefs.getString('email') ?? 'guest@example.com';
    });
  }

  // Fungsi logout yang akan menghapus SharedPreferences dan kembali ke halaman Login
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua data di SharedPreferences
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false, // Menghapus seluruh stack navigasi
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              radius: 30, // Ukuran lingkaran
              backgroundImage: AssetImage('assets/suisei.jpg'),
              backgroundColor: Colors
                  .transparent, // Menjaga transparansi latar belakang jika diperlukan
            ),
            accountName: Text(username ?? 'Guest'),
            accountEmail: Text(email ?? 'guest@example.com'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Beranda"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text("Watchlist"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WatchlistPage()));
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.login),
          //   title: Text("Login"),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => LoginPage()));
          //   },
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              // Konfirmasi logout dengan dialog sebelum logout
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Konfirmasi Logout"),
                    content: Text("Apakah Anda yakin ingin logout?"),
                    actions: [
                      TextButton(
                        child: Text("Batal"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Logout"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                          _logout(); // Panggil fungsi logout
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
