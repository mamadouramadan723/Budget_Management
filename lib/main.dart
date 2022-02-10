import 'package:budget_management/pages/login_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_management/pages/page_daily.dart';
import 'package:budget_management/pages/page_stats.dart';
import 'package:budget_management/pages/page_budget.dart';
import 'package:budget_management/pages/page_profile.dart';
import 'package:budget_management/pages/page_settings.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:budget_management/pages/page_daily_create.dart';
import 'package:budget_management/pages/page_profile_create.dart';
import 'package:budget_management/pages/page_profile_update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> title = ["Transactions", "Stats", "Budget", "Profile"];
    List<Color?> color = [
      Colors.purple,
      Colors.pink,
      Colors.orange,
      Colors.teal
    ];

    List<Widget> pages = [
      const DailyPage(),
      const StatsPage(),
      const BudgetPage(),
      const NotifPage(),
      const ProfilePage()
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: color[_currentIndex],
          title: Text(title[_currentIndex]),
          actions: [
            PopupMenuButton(
                onSelected: (result) {
                  if (result == 1) {
                    Navigator.of(context).pushNamed('/settings');
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text("Settings"),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: const Text("Sign Out"),
                        value: 2,
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                      )
                    ])
          ],
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Daily Transaction
            SalomonBottomBarItem(
              icon: const Icon(Ionicons.md_calendar),
              title: Text(title[_currentIndex]),
              selectedColor: color[_currentIndex],
            ),

            /// Stats
            SalomonBottomBarItem(
              icon: const Icon(Ionicons.md_stats),
              title: Text(title[_currentIndex]),
              selectedColor: color[_currentIndex],
            ),

            /// Budget
            SalomonBottomBarItem(
              icon: const Icon(Ionicons.md_wallet),
              title: Text(title[_currentIndex]),
              selectedColor: color[_currentIndex],
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(Ionicons.md_person),
              title: Text(title[_currentIndex]),
              selectedColor: color[_currentIndex],
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/settings': (context) => const SettingsPage(),
        '/loginRegister': (context) => const AuthGate(),
        '/createProfile': (context) => const CreateProfile(),
        '/updateProfile': (context) => const UpdateProfile(),
        '/createTransaction': (context) => const DailyAddTransaction(),
      },
    );
  }
}
