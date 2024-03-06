import 'package:annex/libs.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
import 'profile.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
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

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  List<Map<String, dynamic>> libraryData1 = [];
  List<Map<String, dynamic>> libraryData2 = [];
  List<Map<String, dynamic>> libraryData3 = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
      var db = await mongo_dart.Db.create(
        "mongodb+srv://johnstonharlea:I62V4Lsg3tjSkxzC@cluster0.ryaxisq.mongodb.net/dart_DB?retryWrites=true&w=majority&appName=Cluster0");
      await db.open(secure: true);

    // Fetch data from collection 1
    var collection1 = db.collection('videoGames');
    await db.open();
    var data1 = await collection1.find().toList();

    // Fetch data from collection 2
    var collection2 = db.collection('books');
    var data2 = await collection2.find().toList();

    // Fetch data from collection 3
    var collection3 = db.collection('vinyls');
    var data3 = await collection3.find().toList();

    await db.close();

    setState(() {
      libraryData1 = data1;
      libraryData2 = data2;
      libraryData3 = data3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLibrarySection("Games", libraryData1),
            _buildLibrarySection("Books", libraryData2),
            _buildLibrarySection("Vinyls", libraryData3),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
            if (value == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LibrariesPage(),
              ),
            );
          }
            if (value == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          }
          if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            );
          }
          setState(() {
            _currentIndex = value;
          });
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