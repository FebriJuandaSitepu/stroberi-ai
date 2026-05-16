import 'package:flutter/material.dart';

import 'home_page.dart';
import 'history_page.dart';
import 'about_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {

  int currentIndex = 0;

  // =========================
  // LIST PAGE
  // =========================

  final List<Widget> pages = [

    const HomePage(),

    const HistoryPage(),

    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[currentIndex],

      // =========================
      // BOTTOM NAVIGATION
      // =========================

      bottomNavigationBar: Container(

        decoration: BoxDecoration(

          color: Colors.white,

          boxShadow: [

            BoxShadow(

              color: Colors.black.withOpacity(0.05),

              blurRadius: 10,

              offset: const Offset(0, -2),
            ),
          ],
        ),

        child: BottomNavigationBar(

          currentIndex: currentIndex,

          onTap: (index) {

            setState(() {

              currentIndex = index;
            });
          },

          backgroundColor: Colors.white,

          elevation: 0,

          selectedItemColor: Colors.redAccent,

          unselectedItemColor: Colors.grey,

          selectedFontSize: 14,

          unselectedFontSize: 12,

          type: BottomNavigationBarType.fixed,

          items: const [

            BottomNavigationBarItem(

              icon: Icon(Icons.home_rounded),

              label: "Home",
            ),

            BottomNavigationBarItem(

              icon: Icon(Icons.history_rounded),

              label: "Riwayat",
            ),

            BottomNavigationBarItem(

              icon: Icon(Icons.info_rounded),

              label: "Tentang",
            ),
          ],
        ),
      ),
    );
  }
}