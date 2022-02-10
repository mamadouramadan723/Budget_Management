import 'package:budget_management/pages/page_profile_create.dart';

import 'login_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_management/models/user.dart';
import 'package:budget_management/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budget_management/json/create_budget_json.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  MyUser myUser = MyUser("", "", "", "", "", "", "");
  String userId = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const AuthGate();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }

        return body();
      },
    );
  }

  Widget body() {
    var size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(color: white, boxShadow: [
        BoxShadow(
          color: grey.withOpacity(0.01),
          spreadRadius: 10,
          blurRadius: 3,
          // changes position of shadow
        ),
      ]),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: (size.width - 50) * 0.4,
                  child: Stack(
                    children: [
                      RotatedBox(
                        quarterTurns: -2,
                        child: CircularPercentIndicator(
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: grey.withOpacity(0.3),
                            radius: 50.0,
                            lineWidth: 6.0,
                            percent: 0.7,
                            progressColor: primary),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: Center(
                            child: myUser.imageUrl.toString().isNotEmpty
                                ? Image.network(
                                    myUser.imageUrl.toString(),
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    categories[7]['icon'],
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: (size.width - 40) * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myUser.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Mail : " + myUser.mail,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: black.withOpacity(0.4)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Phone Number : " + myUser.phoneNumber,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: black.withOpacity(0.4)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Birth : " + myUser.dateOfBirth,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: black.withOpacity(0.4)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Search',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/updateProfile')
                              .then((value) => {reInitState()});
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.01),
                      spreadRadius: 10,
                      blurRadius: 3,
                      // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 25, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: white)),
                      child: const Padding(
                        padding: EdgeInsets.all(13.0),
                        child: Text(
                          "Update",
                          style: TextStyle(color: white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showAlertDialog() {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () async {
        CollectionReference user =
            FirebaseFirestore.instance.collection('users');
        CollectionReference budget =
            FirebaseFirestore.instance.collection('budgets');
        CollectionReference daily =
            FirebaseFirestore.instance.collection('dailies');
        CollectionReference transaction =
            FirebaseFirestore.instance.collection('transactions');

        //delete profile
        user
            .doc(userId)
            .delete()
            .then((value) => {debugPrint("+++++User Deleted")})
            .catchError((error) => debugPrint("Failed to delete user: $error"));

        //delete budget
        budget
            .doc(userId)
            .delete()
            .then((value) => {debugPrint("+++++Budget Deleted")})
            .catchError(
                (error) => debugPrint("Failed to delete budget: $error"));

        //Daily
        daily
            .doc(userId)
            .delete()
            .then((value) => {debugPrint("+++++Daily Deleted")})
            .catchError(
                (error) => debugPrint("Failed to delete daily: $error"));

        //transaction
        transaction
            .doc(userId)
            .delete()
            .then((value) => {debugPrint("+++++Transaction Deleted")})
            .catchError(
                (error) => debugPrint("Failed to delete transaction: $error"));

        Navigator.pop(context);
        //delete user
        await FirebaseAuth.instance.currentUser!.delete();
        //sign out
        await FirebaseAuth.instance.signOut();
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Account Deletion"),
      content: const Text("Are You Sure To Delete Your Account"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    reInitState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  reInitState() {
    userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        myUser = MyUser(
            data["userId"],
            data["name"],
            data["dateOfBirth"],
            data["phoneNumber"],
            data["mail"],
            data["imageUrl"],
            data["creditScore"]);
        print("++++val = " + myUser.toJson().toString());
        setState(() {});
      } else {
        Navigator.pushNamed(context, '/createProfile')
            .then((_) => {reInitState()});
      }
    });
  }
}
