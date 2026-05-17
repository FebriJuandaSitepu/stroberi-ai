import 'dart:async';

import 'package:flutter/material.dart';

import 'main_navigation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    // =========================
    // ANIMATION
    // =========================

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );

    scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) controller.forward();
    });
  }

  // =========================
  // NAVIGASI
  // =========================

  void navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainNavigation(),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF4B5C),
              Color(0xFFFF6B6B),
            ],
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // =========================
                        // LOGO
                        // =========================

                        FadeTransition(
                          opacity: fadeAnimation,
                          child: ScaleTransition(
                            scale: scaleAnimation,
                            child: SizedBox(
                              width: 170,
                              height: 170,
                              child: Image.asset(
                                'assets/images/stroberi_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // =========================
                        // TITLE
                        // =========================

                        FadeTransition(
  opacity: fadeAnimation,
  child: const Text(
    "STROBERI AI",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontSize: 44,
      fontWeight: FontWeight.w900,
      letterSpacing: 3,
      height: 1.1,
      shadows: [
        Shadow(
          blurRadius: 12,
          color: Colors.black45,
          offset: Offset(0, 4),
        ),
        Shadow(
          blurRadius: 20,
          color: Color.fromARGB(80, 255, 0, 0),
          offset: Offset(0, 0),
        ),
      ],
    ),
  ),
),

                        // =========================
                        // SUBTITLE
                        // =========================

                        FadeTransition(
                          opacity: fadeAnimation,
                          child: const Text(
                            "Sistem Deteksi Kematangan Buah",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // =========================
                        // DESKRIPSI
                        // =========================

                        FadeTransition(
                          opacity: fadeAnimation,
                          child: const Text(
                            "Menggunakan metode Hybrid CNN & SVM untuk mendeteksi tingkat kematangan buah stroberi berbasis citra digital.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

                        // =========================
// TOMBOL MULAI DETEKSI
// =========================

FadeTransition(
  opacity: fadeAnimation,
  child: GestureDetector(
    onTap: navigateToMain,
    child: Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFFFF4B5C),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Mulai Deteksi",
            style: TextStyle(
              color:Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Icon(
            Icons.arrow_forward,
            color: Colors.white70,
            size: 20,
          ),
        ],
      ),
    ),
  ),
),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}