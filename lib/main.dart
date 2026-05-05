import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Person {
  String name;
  int age;

  Person(this.name, this.age);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Person App', home: InfoScreen());
  }
}

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  List<Person> personList = [];

  String previewName = '';
  String previewAge = '';

  // Called when Save button is pressed
  void savePerson() {
    String name = nameController.text;
    String ageText = ageController.text;

    if (name.isEmpty || ageText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter name and age')));
      return;
    }

    int age = int.parse(ageText);

    Person p = Person(name, age);
    personList.add(p);

    setState(() {
      previewName = name;
      previewAge = ageText;
      nameController.clear();
      ageController.clear();
    });
  }

  void goToList() {
    if (personList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please save at least one person')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListScreen(personList: personList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Info'), backgroundColor: Colors.blue),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            Text('Name'),
            SizedBox(height: 5),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name',
              ),
            ),

            SizedBox(height: 15),

            // Age field
            Text('Age'),
            SizedBox(height: 5),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter age',
              ),
            ),

            SizedBox(height: 20),

            // Preview section
            Text('Name : $previewName'),
            SizedBox(height: 5),
            Text('Age : $previewAge'),

            SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                ElevatedButton(onPressed: savePerson, child: Text('Save')),
                SizedBox(width: 15),
                ElevatedButton(onPressed: goToList, child: Text('Next')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ListScreen extends StatelessWidget {
  // Receive the list from InfoScreen
  List<Person> personList;

  ListScreen({super.key, required this.personList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List View'), backgroundColor: Colors.blue),
      body: ListView.builder(
        itemCount: personList.length,
        itemBuilder: (context, index) {
          Person p = personList[index];

          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(p.name),
            subtitle: Text('Age: ${p.age}'),
            // Tap to go to details screen
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(person: p),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ── Screen 3: Details ─────────────────────────────────────────────────────────

// ignore: must_be_immutable
class DetailsScreen extends StatelessWidget {
  // Receive one person from ListScreen
  Person person;

  DetailsScreen({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details'), backgroundColor: Colors.blue),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 10),
            Text(
              person.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),

            Text('Age', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 10),
            Text(
              '${person.age}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
