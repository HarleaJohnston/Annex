import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

// to future me work on saving the books and games scanned with this to the DB
class _ScanPageState extends State<ScanPage> {
  String _itemName = '';
  String _itemDescription = '';
  bool _isLoading = false;

  Future<void> fetchItemInfo(String code) async {
    setState(() {
      _isLoading = true;
    });

    final isISBN = code.length == 10 || code.length == 13;
    final url = isISBN
        ? Uri.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:$code')
        : Uri.parse('https://api.upcitemdb.com/prod/trial/lookup?upc=$code');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (isISBN) {
        if (responseData['totalItems'] > 0) {
          final book = responseData['items'][0]['volumeInfo'];
          setState(() {
            _itemName = book['title'];
            _itemDescription = book['description'] ?? 'Description not available';
          });
        } else {
          setState(() {
            _itemName = 'Book not found';
            _itemDescription = '';
          });
        }
      } else {
        final items = responseData['items'];
        // used Chat to fix how I was showing items
        if (items != null && items.isNotEmpty) {
          final item = items[0];
          setState(() {
            _itemName = item['title'];
            _itemDescription = item['description'];
          });
        } else {
          setState(() {
            _itemName = 'Item not found';
            _itemDescription = '';
          });
        }
      }
    } else {
      setState(() {
        _itemName = 'Error';
        _itemDescription = 'Failed to fetch data';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcode != '-1') {
        fetchItemInfo(barcode);
      } else {
        setState(() {
          _itemName = 'Error';
          _itemDescription = 'Failed to scan barcode';
        });
      }
    } catch (e) {
      setState(() {
        _itemName = 'Error';
        _itemDescription = 'Failed to scan barcode';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Item'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: scanBarcode,
                child: Text('Scan Barcode'),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Item Name: $_itemName',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Description: $_itemDescription',
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}