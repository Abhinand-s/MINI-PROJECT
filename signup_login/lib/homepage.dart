import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:signup_login/Entertainment/feed.dart';
import 'package:signup_login/appointment/main.dart';
import 'package:signup_login/appointment/repositories/doctor_repository.dart';
import 'package:signup_login/help/main.dart';
import 'package:signup_login/model_child.dart';
import 'package:signup_login/product/product.dart';
import 'package:signup_login/vaccine/main.dart';
import 'package:signup_login/weather/pages/home_page.dart';

void main() {
  runApp(const MyApp4());
}

class MyApp4 extends StatelessWidget {
  const MyApp4({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home', childName: '',),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.childName}) : super(key: key);

  final String title;
  final String childName;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final ChildModel _childModel = ChildModel();
  Map<String, dynamic>? childDetails;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PersonalPage()),
        );
      }
      if (index == 2) {
        signout();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchChildDetails();
  }

  Future<void> fetchChildDetails() async {
    final snapshot = await _childModel.fetchChildren().first;
    final childDoc = snapshot.docs.firstWhere((doc) => doc['name'] == widget.childName);

    setState(() {
      childDetails = childDoc.data() as Map<String, dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: childDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  // Displaying child's profile section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(childDetails!['image']),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  childDetails!['name'],
                                  style: const TextStyle(
                                    fontFamily: 'Cupertino',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text('DOB: ${childDetails!['dob']}'),
                                Text('Height: ${childDetails!['height']}'),
                                Text('Weight: ${childDetails!['weight']}'),
                                Text('Blood Group: ${childDetails!['blood_group']}'),
                              ],
                            ),
                          ],
                        ),
                          IconButton(
                          icon: const Icon(Icons.cloud, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Homepage()),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      padding: const EdgeInsets.all(20.0),
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      children: <Widget>[
                        _buildGridItem('Alert', Icons.medical_services, Colors.purple),
                        _buildGridItem('Entertainment', Icons.movie, Colors.red),
                        _buildGridItem('TO-DO', Icons.list, Colors.blue),
                        _buildGridItem('Product', Icons.shopping_cart, const Color.fromARGB(255, 247, 198, 76)),
                        _buildGridItem('Hospital', Icons.local_hospital, Colors.pink),
                        _buildGridItem('Appointment', Icons.local_hospital, Colors.orange),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? Colors.grey : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _selectedIndex == 1 ? Colors.grey : Colors.grey,
            ),
            label: 'Personal',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Sign Out',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyApp2()),
          );
        },
        child: const Icon(Icons.help),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildGridItem(String title, IconData icon, Color color) {
    return Card(
      color: color,
      child: InkWell(
        onTap: () {
          if (title == 'Alert') {
            Navigator.push(
              context,
             MaterialPageRoute(builder: (context) => AlertPage(childName: childDetails!['name'])),
            );
          }
          if (title == "TO-DO") {
            Navigator.push(
              context,
               MaterialPageRoute(builder: (context) => ToDoList(childName: childDetails!['name'])), // Pass the child name,
            );
          }
          if (title == "Entertainment") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryList()),
            );
          }
          if (title == "Product") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryList1()),
            );
          }
          if (title == "Hospital") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Hospital()),
            );
          }
          if (title == "Appointment") {
            final doctorRepository = DoctorRepository();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppScreen(doctorRepository: doctorRepository)),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 40.0, color: Colors.white),
              Text(title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertPage extends StatelessWidget {
  final String childName;

  AlertPage({required this.childName});

  final List<Map<String, String>> vaccines = [
    {"name": "BCG", "age": "At birth", "details": "Details about BCG"},
    {"name": "Hepatitis B", "age": "At birth, 1 month, 6 months", "details": "Details about Hepatitis B"},
    {"name": "Polio", "age": "2 months, 4 months, 6-18 months", "details": "Details about Polio"},
    {"name": "DTaP", "age": "2 months, 4 months, 6 months, 15-18 months", "details": "Details about DTaP"},
    {"name": "Hib", "age": "2 months, 4 months, 6 months, 12-15 months", "details": "Details about Hib"},
    {"name": "PCV", "age": "2 months, 4 months, 6 months, 12-15 months", "details": "Details about PCV"},
    {"name": "Rotavirus", "age": "2 months, 4 months, 6 months", "details": "Details about Rotavirus"},
    {"name": "MMR", "age": "12-15 months", "details": "Details about MMR"},
    {"name": "Varicella", "age": "12-15 months", "details": "Details about Varicella"},
    {"name": "Hepatitis A", "age": "12-23 months", "details": "Details about Hepatitis A"},
  ];

  final List<Map<String, String>> medicines = [
    {"name": "Paracetamol", "usage": "Fever and pain relief", "details": "Details about Paracetamol"},
    {"name": "Ibuprofen", "usage": "Pain and inflammation", "details": "Details about Ibuprofen"},
    {"name": "Amoxicillin", "usage": "Bacterial infections", "details": "Details about Amoxicillin"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alert - Essential Vaccines and Medicines"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Essential Vaccines",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...vaccines.map((vaccine) => ListTile(
                  title: Text(vaccine["name"]!),
                  subtitle: Text("Recommended Age: ${vaccine["age"]!}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VaccineDetailsPage(
                          childName: childName,
                          vaccineName: vaccine["name"]!,
                          recommendedAge: vaccine["age"]!,
                          additionalDetails: vaccine["details"]!,
                        ),
                      ),
                    );
                  },
                )),
            const SizedBox(height: 20),
            const Text(
              "Essential Medicines",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...medicines.map((medicine) => ListTile(
                  title: Text(medicine["name"]!),
                  subtitle: Text("Usage: ${medicine["usage"]!}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicineDetailsPage(
                          childName: childName,
                          medicineName: medicine["name"]!,
                          usage: medicine["usage"]!,
                          additionalDetails: medicine["details"]!,
                        ),
                      ),
                    );
                  },
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp1(childName: childName)),
                );
              },
              child: const Text("Add Medicine Reminder"),
            ),
          ],
        ),
      ),
    );
  }
}



class MedicineDetailsPage extends StatefulWidget {
  final String childName;
  final String medicineName;
  final String usage;
  final String additionalDetails;

  MedicineDetailsPage({
    required this.childName,
    required this.medicineName,
    required this.usage,
    required this.additionalDetails,
  });

  @override
  _MedicineDetailsPageState createState() => _MedicineDetailsPageState();
}

class _MedicineDetailsPageState extends State<MedicineDetailsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isReminderSet = false;
  bool _isReminderDeleted = false;

  @override
  void initState() {
    super.initState();
    _checkReminder();
  }

  void _checkReminder() async {
    DocumentSnapshot doc = await _firestore.collection('reminders').doc(widget.childName).get();
    setState(() {
      _isReminderSet = doc.exists;
    });
  }

  void _setReminder() async {
    await _firestore.collection('reminders').doc(widget.childName).set({
      'medicine': widget.medicineName,
      'usage': widget.usage,
      'additionalDetails': widget.additionalDetails,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _isReminderSet = true;
      _isReminderDeleted = false;
    });
  }

  void _deleteReminder() async {
    await _firestore.collection('reminders').doc(widget.childName).delete();

    setState(() {
      _isReminderSet = false;
      _isReminderDeleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicineName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.medicineName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Usage: ${widget.usage}"),
            SizedBox(height: 10),
            Text("Additional Details: ${widget.additionalDetails}"),
            Spacer(),
            if (_isReminderSet)
              Text(
                "Reminder is set",
                style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (_isReminderDeleted)
              Text(
                "Reminder is deleted",
                style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _setReminder,
              child: Text("Set Reminder"),
            ),
            ElevatedButton(
              onPressed: _deleteReminder,
              child: Text("Delete Reminder"),
            ),
          ],
        ),
      ),
    );
  }
}

class VaccineDetailsPage extends StatefulWidget {
  final String childName;
  final String vaccineName;
  final String recommendedAge;
  final String additionalDetails;

  VaccineDetailsPage({
    required this.childName,
    required this.vaccineName,
    required this.recommendedAge,
    required this.additionalDetails,
  });

  @override
  _VaccineDetailsPageState createState() => _VaccineDetailsPageState();
}

class _VaccineDetailsPageState extends State<VaccineDetailsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isReminderSet = false;
  bool _isReminderDeleted = false;

  @override
  void initState() {
    super.initState();
    _checkReminder();
  }

  void _checkReminder() async {
    DocumentSnapshot doc = await _firestore.collection('vaccine_reminders').doc('${widget.childName}-${widget.vaccineName}').get();
    setState(() {
      _isReminderSet = doc.exists;
    });
  }

  void _setReminder() async {
    await _firestore.collection('vaccine_reminders').doc('${widget.childName}-${widget.vaccineName}').set({
      'vaccine': widget.vaccineName,
      'recommendedAge': widget.recommendedAge,
      'additionalDetails': widget.additionalDetails,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _isReminderSet = true;
      _isReminderDeleted = false;
    });
  }

  void _deleteReminder() async {
    await _firestore.collection('vaccine_reminders').doc('${widget.childName}-${widget.vaccineName}').delete();

    setState(() {
      _isReminderSet = false;
      _isReminderDeleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vaccineName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.vaccineName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Recommended Age: ${widget.recommendedAge}"),
            const SizedBox(height: 10),
            Text("Additional Details: ${widget.additionalDetails}"),
            const Spacer(),
            if (_isReminderSet)
              Text(
                "Reminder is set",
                style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (_isReminderDeleted)
              Text(
                "Reminder is deleted",
                style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _setReminder,
              child: const Text("Set Reminder"),
            ),
            ElevatedButton(
              onPressed: _deleteReminder,
              child: const Text("Delete Reminder"),
            ),
          ],
        ),
      ),
    );
  }
}



//ToDo page


class ToDoList extends StatefulWidget {
  final String childName;

  ToDoList({required this.childName});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TextEditingController _textFieldController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late CollectionReference _toDoCollection;

  @override
  void initState() {
    super.initState();
    _toDoCollection = FirebaseFirestore.instance
        .collection('todos')
        .doc(_auth.currentUser!.uid)
        .collection(widget.childName); // Use child's name as the collection key
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[100],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('To-Do List'),
          backgroundColor: Colors.lightGreen,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _toDoCollection.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            final List<DocumentSnapshot> _toDoList = snapshot.data!.docs;

            return ListView(
              children: _toDoList.map((DocumentSnapshot document) {
                Map<String, dynamic> item = document.data() as Map<String, dynamic>;
                return _buildToDoItem(document, item);
              }).toList(),
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => _displayDialog(context, addTodoItem: (title) => _addTodoItem(title)),
              tooltip: 'Add Item',
              child: Icon(Icons.add),
            ),
            // Uncomment the following lines if you want to include the sign-out button
            // SizedBox(width: 10), // Add some spacing between the buttons
            // FloatingActionButton(
            //    onPressed: (() => signout()),
            //    tooltip: 'Sign Out',
            //    child: Icon(Icons.logout),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _addTodoItem(String title) {
    return _toDoCollection.add({
      "title": title,
      "done": false,
    });
  }

  Future<void> _updateTodoItem(DocumentSnapshot item, String title) {
    return _toDoCollection.doc(item.id).update({
      "title": title,
    });
  }

  Widget _buildToDoItem(DocumentSnapshot item, Map<String, dynamic> data) {
    return ListTile(
      title: Text(
        data["title"],
        style: data["done"]
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              )
            : null,
      ),
      trailing: Wrap(
        spacing: 12,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _displayDialog(context,
                addTodoItem: (title) => _updateTodoItem(item, title),
                initialText: data["title"]),
          ),
          IconButton(
            icon: data["done"] ? Icon(Icons.undo, color: Colors.orange) : Icon(Icons.done, color: Colors.green),
            onPressed: () => _toggleDone(item, data),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteTodoItem(item),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTodoItem(DocumentSnapshot item) {
    return _toDoCollection.doc(item.id).delete();
  }

  Future<void> _toggleDone(DocumentSnapshot item, Map<String, dynamic> data) {
    return _toDoCollection.doc(item.id).update({
      "done": !data["done"],
    });
  }

  Future<Future> _displayDialog(BuildContext context, {required Function(String) addTodoItem, String initialText = ''}) async {
    _textFieldController.text = initialText;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a task to your list'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Enter task here'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                Navigator.of(context).pop();
                addTodoItem(_textFieldController.text);
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

         
//product page
class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('product'),
      ),
      body: const Center(
        child: Text(
          'This is the product page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

//hospital page



class Hospital extends StatelessWidget {
  const Hospital({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of random hospital names
    final List<String> hospitalNames = [
      'City Hospital',
      'Green Clinic',
      'Health Plus',
      'Life Care Hospital',
      'MediCure',
      'Wellness Center',
      'Healing Touch',
      'Health First',
      'Care Hospital',
      'Life Line'
    ];

    // List of random telephone numbers
    final List<String> telephoneNumbers = [
      '(123) 456-7890',
      '(234) 567-8901',
      '(345) 678-9012',
      '(456) 789-0123',
      '(567) 890-1234',
      '(678) 901-2345',
      '(789) 012-3456',
      '(890) 123-4567',
      '(901) 234-5678',
      '(012) 345-6789'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital'),
      ),
      body: ListView.builder(
        itemCount: hospitalNames.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.local_hospital),
              title: Text(hospitalNames[index]),
              subtitle: Text('Telephone: ${telephoneNumbers[index]}'),
              trailing: IconButton(
                icon: Icon(Icons.directions),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HospitalDetails(
                        name: hospitalNames[index],
                        telephone: telephoneNumbers[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// Function to generate a random double between two values
double getRandomDouble(double min, double max) {
  final Random random = Random();
  return min + random.nextDouble() * (max - min);
}

class HospitalDetails extends StatelessWidget {
  final String name;
  final String telephone;

  const HospitalDetails({Key? key, required this.name, required this.telephone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate random latitude and longitude for the hospital
    double latitude = getRandomDouble(37.7, 37.8); // Example latitude range for San Francisco
    double longitude = getRandomDouble(-122.5, -122.4); // Example longitude range for San Francisco

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hospital Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Name: $name', style: TextStyle(fontSize: 16)),
            Text('Telephone: $telephone', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(
              'Directions to the Hospital',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Display the map with the random location
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 14.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(name),
                    position: LatLng(latitude, longitude),
                    infoWindow: InfoWindow(title: name),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}






//personal page
class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  // List of random child names
  final List<String> childNames = [
    'AMMU',
    'Emma',
    'Noah',
    'Olivia',
    'William',
    'Ava',
    'James',
    'Isabella',
    'Logan',
    'Sophia'
  ];

  // Currently selected child
  String? selectedChild;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Column(
        children: <Widget>[
          DropdownButton<String>(
            value: selectedChild,
            hint: const Text('Select a child'),
            onChanged: (String? newValue) {
              setState(() {
                selectedChild = newValue;
              });
            },
            items: childNames.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          if (selectedChild != null)
            Text(
              'Personal details for $selectedChild:\n'
              'Age: ${Random().nextInt(10) + 1}\n'
              'Height: ${Random().nextInt(50) + 50} cm\n'
              'Weight: ${Random().nextInt(20) + 10} kg',
              style: const TextStyle(fontSize: 24),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Personal',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}



