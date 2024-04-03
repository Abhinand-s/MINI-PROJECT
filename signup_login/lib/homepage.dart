import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/Entertainment/feed.dart';
import 'package:signup_login/vaccine/main.dart';
import 'package:signup_login/weather/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
 signout()async{
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://cdn-files.cloud/wp-content/blogs.dir/32/files/2018/03/9-tips-beautiful-baby-photos-aperture.jpg'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'AMMU S ',
                            style: TextStyle(
                              fontFamily: 'Cupertino',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text('Age 1 years | Female'),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.wind_power),
                    onPressed: () {
                       Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
                    },
                  ),
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
                  _buildGridItem(
                      'Alert', Icons.medical_services, Colors.purple),
                  _buildGridItem('Entertainment', Icons.movie, Colors.red),
                  _buildGridItem('TO-DO', Icons.list, Colors.blue),
                  _buildGridItem('Product', Icons.shopping_cart,const Color.fromARGB(255, 247, 198, 76)),
                  _buildGridItem('Hospital', Icons.local_hospital, Colors.pink),
                  _buildGridItem('Help', Icons.help, Colors.green),
                ],
              ),
            ),
          ],
          
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _selectedIndex == 0
                    ? Colors.grey
                    : Colors.grey), //color change currently not working
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _selectedIndex == 1
                    ? Colors.grey
                    : Colors.grey), //color change currently not working
            label: 'Personal',
          ),
           const BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Sign Out',
          )
          
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
              MaterialPageRoute(builder: (context) => const MyApp1()),
            );
          }
          if (title == "TO-DO") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ToDoList()),
            );
          }
          if (title == "Entertainment") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Feed()),
            );
          }
          if (title == "Product") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Product()),
            );
          }
          if (title == "Hospital") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Hospital()),
            );
          }
          if (title == "Help") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Help()),
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

// use all pages in single dart file last stage it may change to different file

//vaccine page

// class VaccineAlertPage extends StatefulWidget {
//   const VaccineAlertPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _VaccineAlertPageState createState() => _VaccineAlertPageState();
// }

// class _VaccineAlertPageState extends State<VaccineAlertPage> {
//   List<TextEditingController> vaccineControllers = [TextEditingController()];
//   List<TextEditingController> dateControllers = [TextEditingController()];
//   List<TextEditingController> commentControllers = [TextEditingController()];
//   List<bool> isEditing = [false];
//   DateTime selectedDate = DateTime.now();

//   Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2015, 8),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         controller.text = "${selectedDate.toLocal()}".split(' ')[0];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Vaccine Alert'),
//         backgroundColor: Colors.lightBlue[100],
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: SizedBox(
//             height: 330,
//             child: PageView.builder(
//               itemCount: vaccineControllers.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
//                     child: Card(
//                       color: Colors.lightBlue[50],
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Stack(
//                           children: <Widget>[
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 TextField(
//                                   controller: vaccineControllers[index],
//                                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                   decoration: const InputDecoration(labelText: 'Name of Vaccine'),
//                                   enabled: isEditing[index],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 TextField(
//                                   controller: dateControllers[index],
//                                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                   decoration: const InputDecoration(labelText: 'Date of Vaccination'),
//                                   onTap: () {
//                                     _selectDate(context, dateControllers[index]);
//                                   },
//                                   enabled: isEditing[index],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 TextField(
//                                   controller: commentControllers[index],
//                                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                   decoration: const InputDecoration(labelText: 'Comments'),
//                                   enabled: isEditing[index],
//                                 ),
//                                 const Spacer(),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     // Implement your appointment checking logic here
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.lightBlue[100],
//                                   ),
//                                   child: const Text('Check Appointment'),
//                                 ),
//                               ],
//                             ),
//                             Positioned(
//                               right: 0,
//                               bottom: 0,
//                               child: Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(isEditing[index] ? Icons.check : Icons.edit),
//                                     color: Colors.lightBlue,
//                                     onPressed: () {
//                                       setState(() {
//                                         isEditing[index] = !isEditing[index];
//                                       });
//                                     },
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete),
//                                     color: Colors.red,
//                                     onPressed: () {
//                                       setState(() {
//                                         vaccineControllers.removeAt(index);
//                                         dateControllers.removeAt(index);
//                                         commentControllers.removeAt(index);
//                                         isEditing.removeAt(index);
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             vaccineControllers.add(TextEditingController());
//             dateControllers.add(TextEditingController());
//             commentControllers.add(TextEditingController());
//             isEditing.add(false);
//           });
//         },
//         backgroundColor: Colors.lightBlue[100],
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

//ToDo page
class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<Map<String, dynamic>> _toDoList = [];
  final TextEditingController _textFieldController = TextEditingController();
  signout()async{
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[100],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('To-Do List'),backgroundColor: Colors.lightGreen,),
        body: ListView(children: _getItems()),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => _displayDialog(context, addTodoItem: _addTodoItem),
              tooltip: 'Add Item',
              child: Icon(Icons.add),
            ),
            SizedBox(width: 10), // Add some spacing between the buttons
            // FloatingActionButton(
            //    onPressed: (()=>signout()),
            //   tooltip: 'Sign Out',
            //   child: Icon(Icons.logout),
            // ),
          ],
        ),
      ),
    );
  }

  void _addTodoItem(String title) {
    setState(() {
      _toDoList.add({"title": title, "done": false});
    });
    _textFieldController.clear();
  }

  void _updateTodoItem(Map<String, dynamic> item, String title) {
    setState(() {
      item["title"] = title;
    });
    _textFieldController.clear();
  }

  Widget _buildToDoItem(Map<String, dynamic> item) {
    return ListTile(
      title: Text(
        item["title"],
        style: item["done"]
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
                initialText: item["title"]),
          ),
          IconButton(
            icon: item["done"] ? Icon(Icons.undo, color: Colors.orange) : Icon(Icons.done, color: Colors.green),
            onPressed: () => _toggleDone(item),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteTodoItem(item),
          ),
        ],
      ),
    );
  }

  void _deleteTodoItem(Map<String, dynamic> item) {
    setState(() {
      _toDoList.remove(item);
    });
  }

  void _toggleDone(Map<String, dynamic> item) {
    setState(() {
      item["done"] = !item["done"];
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
              )
            ],
          );
        });
  }

  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (Map<String, dynamic> item in _toDoList) {
      _todoWidgets.add(_buildToDoItem(item));
    }
    return _todoWidgets;
  }
}

//subclass parentingtips
// class ParentingTips extends StatelessWidget {
//   const ParentingTips({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Parenting Tips'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView(
//           children: const <Widget>[
//             ListTile(
//               leading: Icon(Icons.star),
//               title: Text('Show love and affection: Children thrive on love and affection. Make sure to express your love for them regularly through words and actions.'),
//             ),
//             ListTile(
//               leading: Icon(Icons.star),
//               title: Text('Set a good example: Children learn by observing their parents. Be a role model by demonstrating the behavior you want to see in them.'),
//             ),
//             ListTile(
//               leading: Icon(Icons.star),
//               title: Text('Be consistent: Establish clear rules and expectations, and be consistent in enforcing them. This helps children feel secure and understand boundaries.'),
//             ),
//             ListTile(
//               leading: Icon(Icons.star),
//               title: Text('Communicate effectively: Listen to your child\'s thoughts and feelings, and communicate openly and honestly with them. Encourage them to do the same.'),
//             ),
//             ListTile(
//               leading: Icon(Icons.star),
//               title: Text('Encourage independence: Allow your child to make age-appropriate decisions and learn from their mistakes. This helps them develop independence and self-confidence.'),
//             ),
//             ListTile(
//               leading: Icon(Icons.star),
//               title: Text('Provide structure and routine: Children thrive on routine. Establishing a regular schedule can help them feel more secure and make transitions easier.'),
//             ),
//             ListTile(
//               leading: Icon(Icons.star),
//               title: Text('Encourage healthy habits: Teach your child the importance of healthy eating, exercise, and good hygiene habits. Set a good example by practicing these habits yourself.'),
//             ),
//             ListTile(
//               leading: Icon(Icons.star),
//               title: Text('Spend quality time together: Make time for one-on-one activities with your child. This helps strengthen your bond and creates lasting memories.'),
//             ),
//             ListTile(
//               leading: Icon(Icons.star),
//               title: Text('Be patient and understanding: Parenting can be challenging, and children will make mistakes. Be patient and understanding, and use mistakes as opportunities for learning and growth.'),
//             ),
//             ListTile(
//               leading: Icon(Icons.star),
//               title: Text('Seek support when needed: Parenting can be overwhelming at times. Don\'t hesitate to seek support from family, friends, or a professional if you need help or advice.'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//subclass childcare tips
// class ChildHealthTips extends StatelessWidget {
//   const ChildHealthTips({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Child Health Tips'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(8),
//         children: const <Widget>[
//           ListTile(
//             title: Text('Healthy Diet:', style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Provide a balanced diet rich in fruits, vegetables, whole grains, and lean proteins to support growth and development.'),
//           ),
//           ListTile(
//             title: Text('Physical Activity:', style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Encourage regular physical activity to strengthen muscles and bones and promote overall health.'),
//           ),
//           ListTile(
//             title: Text('Adequate Sleep:', style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Ensure your child gets enough sleep according to their age to support growth, development, and overall well-being.'),
//           ),
//           ListTile(
//             title: Text('Limit Screen Time:', style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Limit the amount of time your child spends on screens (TV, computer, smartphone) to promote physical activity and social interaction.'),
//           ),
//           ListTile(
//             title: Text('Hygiene:', style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Teach and encourage good hygiene practices, such as regular handwashing, to prevent the spread of germs and illness.'),
//           ),
//           ListTile(
//             title: Text('Regular Check-ups:', style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Schedule regular check-ups with a pediatrician to monitor your child\'s growth and development and address any health concerns.'),
//           ),
//           ListTile(
//             title: Text('Immunizations:', style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Stay up-to-date with your child\'s immunizations to protect them from serious diseases.'),
//           ),
//           ListTile(
//             title: Text('Safety:', style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Ensure your child wears appropriate safety gear when engaging in physical activities and teach them about road safety, fire safety, etc.'),
//           ),
//           ListTile(
//             title: Text('Emotional Well-being:', style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Pay attention to your child\'s emotional well-being and provide support and guidance when needed.'),
//           ),
//           ListTile(
//             title: Text('Limit Sugary Drinks and Snacks:', style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Limit the consumption of sugary drinks and snacks to prevent dental issues and promote healthy eating habits.'),
//           ),
//         ],
//       ),
//     );
//   }
// }



//entertainment page
// class Entertainment extends StatelessWidget {
//   const Entertainment({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Entertainment'),
//       ),
//       body: const Center(
//         child: Text(
//           'This is the Entertainment  page',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }

//help page
class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const <Widget>[
          ListTile(
            title: Text('COVID Helpline Number:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('0471-2552056'),
          ),
          ListTile(
            title: Text('Centralized helpline:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('112'),
          ),
          ListTile(
            title: Text('Police:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('112 or 100'),
          ),
          ListTile(
            title: Text('Police Helpline:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('0471-324 3000/4000/5000'),
          ),
          ListTile(
            title: Text('Police Message Centre:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('94 97 900000'),
          ),
          ListTile(
            title: Text('Police Highway Help Line:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('9846100100'),
          ),
          ListTile(
            title: Text('Fire Station:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('101'),
          ),
          ListTile(
            title: Text('Ambulance:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('108'),
          ),
          ListTile(
            title: Text('Women Helpline:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('1091 , 181'),
          ),
          ListTile(
            title: Text('Crime Stopper:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('1090'),
          ),
          ListTile(
            title: Text('Child Helpline:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('1098'),
          ),
          ListTile(
            title: Text('Highway Alert:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('9846100100'),
          ),
          ListTile(
            title: Text('Railway Alert:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('9846200100'),
          ),
          ListTile(
            title: Text('Flood / Disaster Helpline:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('1070 , 1077'),
          ),
          ListTile(
            title: Text('Anti Ragging Helpline:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('1800 180 5522'),
          ),
          ListTile(
            title: Text('DISHA Helpline ( Health ):', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('1056'),
          ),
          ListTile(
            title: Text('Government Contact Centre-Kerala (Citizen\'s Call Centre):', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('0471-155300 0471- 2335523'),
          ),
          ListTile(
            title: Text('Water Supply Authority:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('0484 253 0844'),
          ),
          ListTile(
            title: Text('Electricity Helpline:', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('1912'),
          ),
        ],
      ),
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
  const Hospital({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital'),
      ),
      body: const Center(
        child: Text(
          'This is the Hospital  page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class PersonalPage extends StatelessWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: const Center(
        child: Text(
          'This is the Personal page',
          style: TextStyle(fontSize: 24),
        ),
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




