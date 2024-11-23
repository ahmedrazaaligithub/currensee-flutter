import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/forgetpassword.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/signup.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Signin());
}

class Signin extends StatelessWidget {
  const Signin({super.key});

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
      home: const MySigninPage(title: 'Signin'),
    );
  }
}

class MySigninPage extends StatefulWidget {
  const MySigninPage({super.key, required this.title});
  final String title;

  @override
  State<MySigninPage> createState() => _MySigninPageState();
}

class _MySigninPageState extends State<MySigninPage> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  void SignIn() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      if (email.text.isEmpty || password.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("All fields are required"),
            backgroundColor: Colors.red, // Set the background color to red
          ),
        );
      } else {
        if (auth.currentUser != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => Home()));
        } else {
          UserCredential user = await auth
              .signInWithEmailAndPassword(
                  email: email.text, password: password.text)
              .whenComplete(() {
            Navigator.push(
                context, MaterialPageRoute(builder: (builder) => MyApp()));
          });
          print('user-> $user');
        }
      }
    } catch (e) {
      print('error $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid credentials")));
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
                      controller: email,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        // label: Text(' Email'),
                        hintText: " Enter Your Email",
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
                      onPressed: SignIn,
                      child: Text("LOGIN"),
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
                    width: 200,
                    height: 45,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) => Signup()));
                      },
                      child: Text(
                        "SIGNUP",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 8, 65, 235)),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 45,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => forgetpassword()));
                      },
                      child: Text(
                        "Forget Password",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 8, 65, 235)),
                      ),
                    ),
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
//                       onPressed: SignIn,
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
//                           MaterialPageRoute(builder: (builder) => Signup()));
//                     },
//                     child: Text("need register",style: TextStyle(color: Colors.yellow.shade400),),),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
