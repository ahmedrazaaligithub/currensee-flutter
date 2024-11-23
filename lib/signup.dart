import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/check.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/signin.dart';
import 'package:flutter_application_1/signup.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Signup());
}

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 198, 0)),
        useMaterial3: true,
      ),
      home: const MySignupPage(title: 'Signup'),
    );
  }
}

class MySignupPage extends StatefulWidget {
  const MySignupPage({super.key, required this.title});
  final String title;

  @override
  State<MySignupPage> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  void Signup() async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields are required"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Save user details to Firestore
        await firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'phone': contact, 
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Navigate to Signin page
      
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User registered successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (builder) => check()),
        );

    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //   title: Text(widget.title),
        // ),

        body: SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 255, 255, 255),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image(
                      image: AssetImage('logo/logo.png'),
                      width: 250,
                      // height: 200,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 290),
                    child: TextField(
                      controller: name,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        // label: Text(' Email'),
                        hintText: " Enter Your Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 290),
                    child: TextField(
                      controller: contact,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        // label: Text(' Email'),
                        hintText: " Enter Your Phone No",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 290),
                    child: TextField(
                      controller: email,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        // label: Text(' Email'),
                        hintText: " Enter Your Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 290),
                    child: TextField(
                      controller: password,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: " Enter Your Password",
                        // label: Text(' Password'),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: Signup,
                      child: Text("REGISTER"),
                      style: ElevatedButton.styleFrom(
                        elevation: 15,
                        backgroundColor: Color.fromARGB(255, 255, 198, 0),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 290),
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an Account ?",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 45,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) => Signin()));
                      },
                      child: Text(
                        "SIGNIN",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 8, 65, 235)),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("------------- OR -------------"),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    child: Image.asset(
                  "logo/google.png",
                  height: 50,
                  width: 50,
                )),
                Container(
                    child: Image.asset(
                  "logo/facebook.png",
                  height: 50,
                  width: 50,
                )),
                Container(
                    child: Image.asset(
                  "logo/github.png",
                  height: 50,
                  width: 50,
                )),
              ]),
            ])),
      ),
    ));
  }
}












//       body: Center(
//         child: Center(
//           child: Column(
//             children: [
//               Container(
//                 child: Image(
//                   image: AssetImage('logo/logo.png'),
//                   width: 200,
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: TextField(
//                   controller: email,
//                   decoration: InputDecoration(
//                     hintText: 'your email',
//                     label: Text('your Email'),
//                     // border: OutlineInputBorder(
//                     //   borderRadius: BorderRadius.circular(
//                     //       10), // Adjust this value as needed
//                     // ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: TextField(
//                   controller: password,
//                   decoration: InputDecoration(
//                     hintText: 'your password',
//                     label: Text('your Password'),
//                     // border: OutlineInputBorder(
//                     //   borderRadius: BorderRadius.circular(
//                     //       10),
//                     // ),
//                   ),
//                 ),
//               ),
//               Container(
//                   child: ElevatedButton(
//                       onPressed: Signup,
//                       child: Text("SUBMIT"),
//                       style: ElevatedButton.styleFrom(
//                         elevation: 15,
//                         backgroundColor: Color.fromARGB(255, 255, 198, 0),
//                         foregroundColor:
//                             const Color.fromARGB(255, 255, 255, 255),
//                       ))),
//               Container(
//                 child: TextButton(
//                     onPressed: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (builder) => Signin()));
//                     },
//                     child: Text("need login",style: TextStyle(color: Colors.yellow.shade400),),),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
