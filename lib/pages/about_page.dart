import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF8F8F8),

      appBar: AppBar(

        backgroundColor:
            const Color(0xFFFF4B5C),

        elevation: 0,

        title: const Text(
          "Tentang Aplikasi",
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // =========================
            // LOGO
            // =========================

            Center(

              child: Container(

                width: 140,

                height: 140,

                padding:
                    const EdgeInsets.all(20),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(35),

                  boxShadow: [

                    BoxShadow(

                      color: Colors.black
                          .withOpacity(0.05),

                      blurRadius: 15,

                      offset:
                          const Offset(0, 5),
                    ),
                  ],
                ),

                child: Image.asset(
                  'assets/images/stroberi_logo.png',
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // TITLE
            // =========================

            const Center(

              child: Text(

                "Stroberi AI",

                style: TextStyle(

                  fontSize: 32,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      Color(0xFFFF4B5C),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(

              child: Text(

                "Hybrid CNN & SVM",

                style: TextStyle(

                  fontSize: 18,

                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // =========================
            // DESCRIPTION
            // =========================

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(25),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(25),

                boxShadow: [

                  BoxShadow(

                    color: Colors.black
                        .withOpacity(0.04),

                    blurRadius: 10,

                    offset:
                        const Offset(0, 5),
                  ),
                ],
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: const [

                  Text(

                    "Tentang Aplikasi",

                    style: TextStyle(

                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(

                    "Stroberi AI merupakan aplikasi berbasis Artificial Intelligence yang digunakan untuk mendeteksi tingkat kematangan buah stroberi menggunakan metode Hybrid CNN dan SVM.",

                    style: TextStyle(

                      fontSize: 16,

                      height: 1.7,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(

                    "Aplikasi ini membantu proses klasifikasi stroberi menjadi beberapa kategori seperti matang, setengah matang, dan mentah berdasarkan citra digital.",

                    style: TextStyle(

                      fontSize: 16,

                      height: 1.7,
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

              padding:
                  const EdgeInsets.all(25),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(25),

                boxShadow: [

                  BoxShadow(

                    color: Colors.black
                        .withOpacity(0.04),

                    blurRadius: 10,

                    offset:
                        const Offset(0, 5),
                  ),
                ],
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: const [

                  Text(

                    "Fitur Utama",

                    style: TextStyle(

                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  FeatureItem(
                    icon: Icons.camera_alt,
                    text:
                        "Deteksi menggunakan kamera",
                  ),

                  SizedBox(height: 15),

                  FeatureItem(
                    icon: Icons.image,
                    text:
                        "Upload gambar dari galeri",
                  ),

                  SizedBox(height: 15),

                  FeatureItem(
                    icon: Icons.analytics,
                    text:
                        "Analisis AI real-time",
                  ),

                  SizedBox(height: 15),

                  FeatureItem(
                    icon: Icons.history,
                    text:
                        "Penyimpanan riwayat prediksi",
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

                  color: Colors.grey,

                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(

              child: Text(

                "Version 1.0.0",

                style: TextStyle(

                  color: Colors.grey,

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

          padding:
              const EdgeInsets.all(12),

          decoration: BoxDecoration(

            color: const Color(
              0xFFFF4B5C,
            ).withOpacity(0.1),

            borderRadius:
                BorderRadius.circular(15),
          ),

          child: Icon(

            icon,

            color:
                const Color(0xFFFF4B5C),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(

          child: Text(

            text,

            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}