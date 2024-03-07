import 'package:annex/scan.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
import 'package:annex/add.dart';
import 'package:annex/home.dart';
import 'package:annex/profile.dart';

class LibrariesPage extends StatefulWidget {
  @override
  _LibrariesPageState createState() => _LibrariesPageState();
}

class _LibrariesPageState extends State<LibrariesPage> {
  String _selectedLibrary = 'Books';
  List<Map<String, dynamic>> _libraryData1 = [];
  List<Map<String, dynamic>> _libraryData2 = [];
  List<Map<String, dynamic>> _libraryData3 = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var db = await mongo_dart.Db.create(
        "mongodb+srv://johnstonharlea:I62V4Lsg3tjSkxzC@cluster0.ryaxisq.mongodb.net/dart_DB?retryWrites=true&w=majority&appName=Cluster0");
    await db.open(secure: true);

    var collection1 = db.collection('videoGames');
    var data1 = await collection1.find().toList();

    var collection2 = db.collection('books');
    var data2 = await collection2.find().toList();

    var collection3 = db.collection('vinyls');
    var data3 = await collection3.find().toList();

    await db.close();

    setState(() {
      _libraryData1 = data1;
      _libraryData2 = data2;
      _libraryData3 = data3;
    });
  }

    Container buildLibraryCard(String libraryItemType) {
    return Container(
      width: 150,
      height: 250,
      color: Colors.amber,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              'assets/imgs/whateverICallItOnceIHaveImgs.png',
              fit: BoxFit.cover,
            ),
          ),
          Text(libraryItemType),
        ],
      ),
      margin: const EdgeInsets.all(10.0),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Libraries'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddItemPage()),
              );
            },
            icon: Icon(Icons.add),
          ),
                    IconButton(
            onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanPage()),
              );
            },
            icon: Icon(Icons.camera), 
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLibrarySection("Games", _libraryData1),
            _buildLibrarySection("Books", _libraryData2),
            _buildLibrarySection("Vinyls", _libraryData3),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Adjust this to the appropriate index
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: "Libraries",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
        onTap: (value) {
          if (value == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } if (value == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          } if (value == 0){
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LibrariesPage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildLibrarySection(String title, List<Map<String, dynamic>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var itemData in data)
                buildLibraryCard(itemData['name']),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}