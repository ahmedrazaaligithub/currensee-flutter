import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/contact.dart';
import 'package:flutter_application_1/curense.dart';
import 'package:flutter_application_1/helpnfeedback.dart';
import 'package:flutter_application_1/history.dart';
import 'package:flutter_application_1/signin.dart';

void main() {
  runApp(const ButtomBar());
}

class ButtomBar extends StatelessWidget {
  const ButtomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // Remove the debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  // List of pages corresponding to each tab
  List<Widget> mypage = [
    CurrencyConverterUI(), // Replace with your CurrencyConverterUI widget
    Text("Home Page"),
    Text("Your Library Page"),
    Text("Profile Page"),
  ];

  void item_select(int i) {
    setState(() {
      index = i;
    });
  }

  // Function to show the "Rate Us" popup
  void _showRateUsPopup(BuildContext context) {
    int selectedStars = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Function to get Emoji based on selected stars
            String getEmoji() {
              switch (selectedStars) {
                case 1:
                  return '😢'; // Sad
                case 2:
                  return '😟'; // Poor
                case 3:
                  return '😐'; // Neutral
                case 4:
                  return '😊'; // Happy
                case 5:
                  return '🤩'; // Excited
                default:
                  return '⭐'; // Default
              }
            }

            // Function to get message based on selected stars
            String getMessage() {
              switch (selectedStars) {
                case 1:
                  return 'Oh no!';
                case 2:
                  return 'Poor!';
                case 3:
                  return 'Okay!';
                case 4:
                  return 'Good!';
                case 5:
                  return 'Amazing!';
                default:
                  return 'Rate us!';
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Text(
                      getEmoji(),
                      key: ValueKey<int>(selectedStars),
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    getMessage(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedStars = index + 1;
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          color: selectedStars > index
                              ? Colors.amber
                              : Colors.grey,
                          size: 30,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close popup
                        },
                        child: Text('Not now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print("User rated: $selectedStars stars");
                          Navigator.pop(context); // Close popup
                        },
                        child: Text('Rate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Image.asset(
          "logo/logo.png",
          width: 150,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu), // Hamburger menu icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'User Name',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => History())); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Contact US'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            contactus())); // Open Contact us page
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Feedback'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            HelpAndFeedbackPage())); // Open Help & Feedback page
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.question_answer_outlined),
              title: const Text('Faqs'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => FAQPage())); // Open Faqs page
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Rate Us'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _showRateUsPopup(context); // Show Rate Us popup
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              // onLongPress: ,
              onTap: () async {
                try {
                  // Sign out the user
                  await FirebaseAuth.instance.signOut();

                  // Navigate to the SignIn page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Signin()), // Replace with your SignInPage
                  );
                } catch (e) {
                  // Handle errors if any
                  print("Error during sign out: $e");
                }
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: mypage[index], // Show content based on selected tab
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.grey.shade900,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: item_select, // Handle the bottom nav bar item tap
      ),
    );
  }
}
