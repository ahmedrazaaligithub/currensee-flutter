import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp(const forgetpassword());
}

class forgetpassword extends StatelessWidget {
  const forgetpassword({super.key});

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
 
  TextEditingController email = TextEditingController();

  void forgetpassword() async{
  try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email Has been sent")));
    Navigator.push(context, MaterialPageRoute(builder: (builder) => Signin()));
  }
   catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e"), backgroundColor: Colors.red,));
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       child: Text("Forget Password" , style: TextStyle(
              //         color: Colors.black ,
              //         fontSize: 30,
                      
              //       ),),
              //     ),
              //   ],
              // ),
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
                        hintText: " Enter Your Email ",
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
                    
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: forgetpassword,
                      child: Text("Forget"),
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
