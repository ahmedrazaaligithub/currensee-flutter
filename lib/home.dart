import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/buttom_bar.dart';
import 'package:flutter_application_1/signin.dart';
import 'firebase_options.dart';
import 'curense.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
       home: ButtomBar(),
    );
  }
}

class MyHomeScreenPage extends StatefulWidget {
  const MyHomeScreenPage({super.key, required this.title});
  final String title;

  @override
  State<MyHomeScreenPage> createState() => _MyHomeScreenPageState();
}

class _MyHomeScreenPageState extends State<MyHomeScreenPage> {
void logout ()async{
  try{
  FirebaseAuth user = FirebaseAuth.instance;
  user.signOut();
     Navigator.push(
            context, MaterialPageRoute(builder: (builder) => Signin()));
  if(user.currentUser ==null ){
    
  }
  }
  catch(e){
    print('error $e');
  }

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body:Center(
        child: TextButton(
                    onPressed:logout,
                    child: Text("logout",style: TextStyle(color: Colors.yellow.shade400),),),
              
      )
    );
  }
}
