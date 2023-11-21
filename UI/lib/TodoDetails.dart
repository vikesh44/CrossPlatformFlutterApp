import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoDetails extends StatelessWidget {
  final String title;
  final String description;
  final bool? isDone;

  const TodoDetails({super.key, required this.title, required this.description, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: $description',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              'Status: ${isDone??true?'Completed':'Pending'}',
              style: const TextStyle(fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}
