import 'package:mongo_dart/mongo_dart.dart';

var db = Db(
    'mongodb+srv://johnstonharlea:I62V4Lsg3tjSkxzC@cluster0.ryaxisq.mongodb.net/dart_DB');
var collection = db.collection('users');

void getUser() async {
  await db.open();

  var documents = await collection.find().toList();

  documents.forEach((doc) => print(doc));

  await db.close();
}

void createUser() async {
  await db.open();

  await collection.insertOne({'name': 'Alice', 'age': 25});

  print('User added!');

  await db.close();
}

void updateUser() async {
  await db.open();

  await collection.updateOne(
    where.eq('name', 'Alice'),
    modify.set('age', 26),
  );

  print('User updated!');

  await db.close();
}

void deleteExample() async {
  await db.open();

  await collection.deleteOne(where.eq('name', 'Alice'));

  print('Document deleted successfully.');

  await db.close();
}
