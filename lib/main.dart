import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String appTitle = 'Annex: Multimedia Library';
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff304132)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Annex'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

  Container buildLibraryCard(String libraryItemType) {
    return Container(
        width: 100,
        height: 200,
        color: Colors.amber,
        child: Column(children: [Text("Game Title")]),
        margin: const EdgeInsets.all(10.1));
  }

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(children: [
          buildLibraryCard("Game 1"),
          buildLibraryCard("Game 2"),
          buildLibraryCard("Game 3")
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(currentIndex: 1, items: [
        BottomNavigationBarItem
          (icon: Icon(Icons.library_books), label: "Library"),
        BottomNavigationBarItem
          (icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem
          (icon: Icon(Icons.account_circle), label: "Profile")
      ]),
    );
  }
}
