import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/signup.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        primarySwatch: Colors.blue,
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  /// Function to sign in with email and password
  void SignIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential user = await auth.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        print('user-> $user');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (builder) => const Home()),
        );
      } catch (e) {
        print('error $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid credentials")),
        );
      }
    }
  }

  /// Function to sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId: "498573788944-fo1qpltc1kp3ka8iugj5a98q09vbdvqj.apps.googleusercontent.com"
      ).signIn();
      if (googleUser == null) return; // User canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Google User: ${userCredential.user}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (builder) => const Home()),
      );
    } catch (e) {
      print("Error with Google Sign-In: $e");
    }
  }

  /// Function to sign in with Facebook
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print("Facebook User: ${userCredential.user}");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (builder) => const Home()),
        );
      } else {
        print("Facebook Login Failed: ${result.status}");
      }
    } catch (e) {
      print("Error with Facebook Sign-In: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: SignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  const Text("Or login with"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: signInWithGoogle,
                        icon: const Icon(Icons.g_mobiledata,
                            size: 40, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: signInWithFacebook,
                        icon: const Icon(Icons.facebook,
                            size: 40, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const Signup()),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
