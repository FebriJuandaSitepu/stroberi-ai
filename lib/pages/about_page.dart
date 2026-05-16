import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // =========================
  // APP COLORS
  // =========================

  static const Color primaryColor = Color(0xFFFF4B5C);
  static const Color backgroundColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "Tentang Aplikasi",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =========================
            // LOGO
            // =========================

            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: Colors.white10, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset('assets/images/stroberi_logo.png'),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // TITLE
            // =========================

            const Center(
              child: Text(
                "STROBERI AI",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "HYBRID CNN & SVM",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white54,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // =========================
            // DESCRIPTION
            // =========================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white10, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tentang Aplikasi",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Stroberi AI merupakan aplikasi berbasis Artificial Intelligence yang digunakan untuk mendeteksi tingkat kematangan buah stroberi menggunakan metode Hybrid CNN dan SVM.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Aplikasi ini membantu proses klasifikasi stroberi menjadi beberapa kategori seperti matang, setengah matang, dan mentah berdasarkan citra digital.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // FEATURE
            // =========================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white10, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fitur Utama",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  FeatureItem(
                    icon: Icons.camera_alt,
                    text: "Deteksi menggunakan kamera",
                  ),
                  SizedBox(height: 15),
                  FeatureItem(
                    icon: Icons.image,
                    text: "Upload gambar dari galeri",
                  ),
                  SizedBox(height: 15),
                  FeatureItem(
                    icon: Icons.analytics,
                    text: "Analisis AI real-time",
                  ),
                  SizedBox(height: 15),
                  FeatureItem(
                    icon: Icons.history,
                    text: "Penyimpanan riwayat prediksi",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // FOOTER
            // =========================

            const Center(
              child: Text(
                "Developed with Flutter & FastAPI",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "Version 1.0.0",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// =========================
// FEATURE ITEM
// =========================

class FeatureItem extends StatelessWidget {

  final IconData icon;
  final String text;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4B5C).withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFF4B5C),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}