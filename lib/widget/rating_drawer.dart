import 'package:flutter/material.dart';

class RatingDrawer extends StatefulWidget {
  const RatingDrawer({Key? key}) : super(key: key);

  @override
  _RatingDrawerState createState() => _RatingDrawerState();
}

class _RatingDrawerState extends State<RatingDrawer> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 3.0; // Gunakan double untuk rating
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rate and Comment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Rating dengan bintang
                  const Text(
                    'Rate the Movie:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          _rating > index ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = (index + 1).toDouble(); // Pastikan rating berupa double
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Comment TextField
                  const Text(
                    'Your Comment:',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFormField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your comment',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Tidak menyimpan data, hanya formalitas
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Your rating and comment were submitted')),
                      );
                      // Menutup drawer setelah submit
                      Navigator.pop(context);
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
