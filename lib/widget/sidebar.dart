import 'package:flutter/material.dart';
import 'package:moviedesu/ui/home.dart';
import 'package:moviedesu/ui/login_page.dart';
import 'package:moviedesu/ui/watchlist_page.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
            accountName: Text("Admin"),
            accountEmail: Text("dev.farhanmaulana@gmail.com"),
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
                 MaterialPageRoute(builder: (context)=>WatchlistPage()));
              },
            ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text("Login"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            ),
          //   ListTile(
          //     leading: Icon(Icons.account_box_sharp),
          //     title: Text("Pasien"),
          //     onTap: () {},
          //   ),
          //   ListTile(
          //     leading: Icon(Icons.logout_rounded),
          //     title: Text("Keluar"),
          //     onTap: () {
          //       Navigator.pushAndRemoveUntil(
          //         context, MaterialPageRoute(builder: (context)=> Login()),(Route<dynamic> route) => false);
          //     },
          //   ),
        ],
      ),
    );
  }
}
