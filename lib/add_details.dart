import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  int count = 1;
  void update() {
    nameController.clear();
    ageController.clear();
    phoneController.clear();
    setState(() {
      count++;
    });
  }

  Future<bool> adduser() async {
    try {
      var userid = "lumin$count";
      await _databaseReference.child("User/$userid").set({
        "name": nameController.text.trim(),
        "age": ageController.text.trim(),
        "phone": phoneController.text.trim(),
      });
      update();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // ---------------- VALIDATIONS ----------------
  final RegExp nameRegExp = RegExp(
    r'^[a-zA-Z ]{3,}$',
  ); // Only letters, min 3 chars
  final RegExp ageRegExp = RegExp(r'^[1-9][0-9]?$|^100$'); // 1–100 only
  final RegExp phoneRegExp = RegExp(r'^[0-9]{10}$'); // Exactly 10 digits
  // ----------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Details"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ---------------- NAME FIELD ----------------
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter name";
                  }
                  if (!nameRegExp.hasMatch(value)) {
                    return "Name must contain only letters (min 3 chars)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---------------- AGE FIELD ----------------
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter age";
                  }
                  if (!ageRegExp.hasMatch(value)) {
                    return "Enter a valid age (1–100)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---------------- PHONE FIELD ----------------
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter phone number";
                  }
                  if (!phoneRegExp.hasMatch(value)) {
                    return "Phone number must be 10 digits";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // ---------------- SUBMIT BUTTON ----------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool? result = await adduser();
                      if (result == true) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("User Added")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("User Not Added")),
                        );
                      }
                    }
                  },
                  child: const Text("Save Details"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
