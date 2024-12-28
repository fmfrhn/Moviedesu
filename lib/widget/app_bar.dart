import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.purple, // Ganti warna AppBar menjadi ungu
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Menempatkan logo dan teks di sebelah kiri
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/moviedesu-nobg.png',
              height: 40, // Menyesuaikan ukuran logo
            ),
          ),
          SizedBox(width: 8), // Memberikan jarak antara logo dan teks
          Text(
            "Moviedesu",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Menambahkan ukuran font jika diinginkan
            ),
          ),
        ],
      ),
      elevation: 4.0, // Menambahkan elevasi untuk memberikan efek bayangan
    );
  }
}
