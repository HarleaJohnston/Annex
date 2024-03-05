import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Excersise extends StatefulWidget {
  @override
  _ExcersiseState createState() => _ExcersiseState();
}

class _ExcersiseState extends State<Excersise> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qoute Display',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuoteDisplayPage(),
    );
  }
}

class QuoteDisplayPage extends StatelessWidget {
  Future<Map<String, dynamic>> fetchQuote() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final List<dynamic> quotesData = json.decode(response.body);
      final randomIndex =
          DateTime.now().millisecondsSinceEpoch % quotesData.length;
      return quotesData[randomIndex];
    } else {
      throw Exception('Failed to fetch quote');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Quote'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchQuote(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return QuoteWidget(quote: snapshot.data);
            }
          },
        ),
      ),
    );
  }
}

class QuoteWidget extends StatelessWidget {
  final Map<String, dynamic>? quote;

  const QuoteWidget({Key? key, this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Title:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(quote?['title'] ?? ''),
          SizedBox(height: 10),
          Text(
            'Body:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(quote?['body'] ?? ''),
        ],
      ),
    );
  }
}
