import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/firebase_options.dart';


void main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Helpnfeedback());
}

class Helpnfeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HelpAndFeedbackPage(),
    );
  }
}

class HelpAndFeedbackPage extends StatelessWidget {
   
   
  @override
  Widget build(BuildContext context) {
    TextEditingController message = TextEditingController();

    void savedata(){
      try {
        FirebaseFirestore db = FirebaseFirestore.instance;
        db.collection("feedback").add({
          "message" : message.text ,
          "feedbacktime" : DateTime.now().toString()
        }).whenComplete((){
           ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Feedback Submited")));
        });
      } catch (e) {
         ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$e")));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Feedback'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Help Section
            Text(
              'Need Help?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'If you have any questions or face any issues using the app, please check the FAQs or contact our support team.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to FAQ page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQPage()),
                );
              },
              child: Text('Visit FAQ'),
            ),
            SizedBox(height: 30),

            // Feedback Section
            Text(
              'Feedback:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We value your feedback to improve the app. Please share your thoughts below.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),

            // Feedback Input
            TextField(
              controller: message,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: savedata ,
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}

// FAQ Page
class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            FAQItem(question: 'How do I convert currency?', answer: 'To convert currency, select the currency you want to convert from and to, then enter the amount.'),
            FAQItem(question: 'Is the exchange rate accurate?', answer: 'The exchange rates are updated periodically based on the latest market data.'),
            FAQItem(question: 'Can I save my favorite currencies?', answer: 'Yes, you can save your frequently used currencies for quicker access.'),
            FAQItem(question: 'How do I contact support?', answer: 'You can reach out to our support team via the "Contact Us" section in the app.'),
          ],
        ),
      ),
    );
  }
}

// FAQ Item Widget
class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          title: Text(
            question,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(answer),
            ),
          ],
        ),
      ),
    );
  }
}
