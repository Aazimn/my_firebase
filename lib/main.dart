import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_firebase/add_details.dart';
import 'package:my_firebase/google_signin_service.dart';
import 'package:my_firebase/log_in_screen.dart';
import 'package:my_firebase/sign_in_screen.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
      home: UserDetailsScreen(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GoogleSigninService _googlesigninservice = GoogleSigninService();
  GoogleSignInAccount? _user;
  Future<void> login() async {
    var data = await _googlesigninservice.signinwithgoogle();
    if (data != null) {
      setState(() {
        _user = data;
      });
    }
  }
Future<void> logout() async {
    await _googlesigninservice.logout();
    setState(() {
      _user=null;
    });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [IconButton(onPressed: (){logout();}, icon: Icon(Icons.settings_power_rounded))],),
      body: Center(
        child: _user == null
            ? ElevatedButton(
                onPressed: () {
                  login();
                },
                child: Text("Sign in with Google"),
              )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(backgroundImage: NetworkImage("${_user!.photoUrl}",),radius: 100,),
                Text("${_user!.displayName}"),
                Text("${_user!.email}"),
                Text("${_user!.id}"),
              ],
            ),
      ),
    );
  }
}