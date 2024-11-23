import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart'; // For date formatting

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const History());
}

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conversion History',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 198, 0)),
        useMaterial3: true,
      ),
      home: const MyHistoryPage(title: 'Conversion History'),
    );
  }
}

class MyHistoryPage extends StatefulWidget {
  const MyHistoryPage({super.key, required this.title});
  final String title;

  @override
  State<MyHistoryPage> createState() => _MyHistoryPageState();
}

class _MyHistoryPageState extends State<MyHistoryPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> conversions = [];

  @override
  void initState() {
    super.initState();
    fetchConversions();
  }

  Future<void> fetchConversions() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user);
    if (user != null) {
      try {
        // Fetch all conversions of the logged-in user
        QuerySnapshot querySnapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('conversions')
            .orderBy('timestamp', descending: true)
            .get();
      print(querySnapshot);
        setState(() {
          // Extract data and convert to a list of maps
          conversions = querySnapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
        });
      } catch (e) {
        print("Error fetching conversions: $e");
      }
    } else {
      print("No user is currently logged in.");
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: conversions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: conversions.length,
              itemBuilder: (context, index) {
                final conversion = conversions[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      '${conversion['amount']} ${conversion['fromCurrency']} → ${conversion['convertedAmount']} ${conversion['toCurrency']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Date: ${formatTimestamp(conversion['timestamp'])}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
