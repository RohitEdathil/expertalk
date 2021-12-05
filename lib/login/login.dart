import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expertalk/components/wide_button/wide_button.dart';
import 'package:expertalk/expert_or_participant/expert_or_participant.dart';
import 'package:expertalk/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  final Role role;
  const LoginScreen({Key? key, required this.role}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? error;
  var hide = true;
  bool loading = false;

  void _toggleHide() => setState(() => hide = !hide);

  void _login() async {
    setState(() => loading = true);
    final auth = FirebaseAuth.instance;
    try {
      final user = await auth.signInWithEmailAndPassword(
          email: _emailController.value.text.trim(),
          password: _passwordController.value.text);
      final db = FirebaseFirestore.instance;
      db.collection("users").doc(user.user!.uid).get().then((userData) async {
        final userRole = userData["role"];
        final roleAccess = widget.role == Role.expert
            ? ((userRole == "expert") ? true : false)
            : ((userRole == "participant") ? true : false);
        if (!roleAccess) {
          auth.signOut();
          setState(() {
            loading = false;
            error = "You can't login in this role.";
          });
          return;
        }
        if (widget.role == Role.participant) {
          final String userHackathon = userData["hackathon"];
          final bool isLive = (await db
              .collection("hackathons")
              .doc(userHackathon)
              .get())["live"];
          if (!isLive) {
            setState(() {
              loading = false;
              error = "Your event isn't live now.";
            });
            return;
          }
        }
        Navigator.of(context).pushAndRemoveUntil(
          PageTransition(
              child: const HomeScreen(), type: PageTransitionType.bottomToTop),
          (route) => false,
        );
      });
    } on FirebaseAuthException catch (e) {
      var m = e.message;
      if (m == "Given String is empty or null") {
        m = "Fields can't be empty";
      }
      setState(() {
        error = m;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).primaryColor;
    return Scaffold(
      floatingActionButton: loading
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
          : WideButton(callback: _login, text: "Go"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Login",
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      ?.copyWith(color: fg),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(color: fg),
                  decoration: InputDecoration(
                      label: const Text("E-mail"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.email, color: fg)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                    controller: _passwordController,
                    obscureText: hide,
                    style: TextStyle(color: fg),
                    decoration: InputDecoration(
                        label: const Text("Password"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.lock, color: fg),
                        suffixIcon: IconButton(
                            onPressed: _toggleHide,
                            icon: Icon(
                              hide
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                            )))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(error ?? '',
                    style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
