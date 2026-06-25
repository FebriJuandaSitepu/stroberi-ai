import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../models/history_model.dart';
import '../data/history_data.dart';
import '../services/history_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // =========================
  // APP COLORS
  // =========================

  static const Color primaryColor = Color(0xFFFF4B5C);
  static const Color secondaryColor = Color(0xFFFF6B6B);
  static const Color backgroundColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF1A1A1A);

  // =========================
  // VARIABLES
  // =========================

  final ImagePicker picker = ImagePicker();
  XFile? imageFile;
  Uint8List? imageBytes;
  String result = "-";
  double confidence = 0;
  bool isLoading = false;
  bool isRequestRunning = false;
  bool isSaved = false;

  // =========================
  // LOADING TEXTS
  // =========================

  final List<String> loadingTexts = [
    "AI sedang membaca gambar...",
    "Menganalisis tingkat kematangan...",
    "Mengekstrak fitur CNN...",
    "Mengklasifikasi dengan SVM...",
    "Menyelesaikan prediksi...",
  ];

  int loadingIndex = 0;
  Timer? loadingTimer;

  // =========================
  // GET DESCRIPTION
  // =========================

  String getDescription() {
    if (result == "Matang") {
      return "Buah stroberi menunjukkan pigmentasi merah merata di seluruh permukaan dengan tekstur biji yang menonjol sempurna.";
    } else if (result == "Setengah Matang") {
      return "Buah stroberi menunjukkan warna campuran merah dan putih/kuning, sebagian permukaan belum matang sempurna.";
    } else if (result == "Mentah") {
      return "Buah stroberi masih berwarna hijau atau putih, belum menunjukkan tanda-tanda kematangan yang cukup.";
    }
    return "";
  }

  // =========================
  // GET STATUS LABEL
  // =========================

  String getStatusLabel() {
    if (result == "Matang") return "Optimal";
    if (result == "Setengah Matang") return "Sedang";
    if (result == "Mentah") return "Belum Siap";
    return "";
  }

  // =========================
  // START LOADING
  // =========================

  void startLoadingAnimation() {
    loadingIndex = 0;
    loadingTimer?.cancel();
    loadingTimer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        if (!mounted) return;
        setState(() {
          loadingIndex++;
          if (loadingIndex >= loadingTexts.length) {
            loadingIndex = 0;
          }
        });
      },
    );
  }

  // =========================
  // STOP LOADING
  // =========================

  void stopLoadingAnimation() {
    loadingTimer?.cancel();
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    loadingTimer?.cancel();
    super.dispose();
  }

  // =========================
  // PICK IMAGE
  // =========================

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        imageFile = pickedFile;
        imageBytes = bytes;
        result = "-";
        confidence = 0;
        isSaved = false;
      });
      await predictImage();
    }
  }

  // =========================
  // DETEKSI ULANG
  // =========================

  void deteksiUlang() {
    setState(() {
      imageFile = null;
      imageBytes = null;
      result = "-";
      confidence = 0;
      isSaved = false;
    });
  }

  // =========================
  // SIMPAN KE RIWAYAT
  // =========================

  Future<void> simpanKeRiwayat() async {
    if (imageBytes == null || result == "-") return;

    historyList.insert(
      0,
      HistoryModel(
        result: result,
        confidence: confidence,
        imagePath: imageFile!.path,
        createdAt: DateTime.now(),
        imageBytes: imageBytes,
      ),
    );

    await HistoryService.saveHistory();

    setState(() => isSaved = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Berhasil disimpan ke riwayat!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  // =========================
  // IMAGE PICKER OPTION
  // =========================

  void showImagePickerOption() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Pilih Gambar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        pickImage(ImageSource.camera);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.camera_alt, size: 50, color: primaryColor),
                            SizedBox(height: 15),
                            Text(
                              "Kamera",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.image, size: 50, color: secondaryColor),
                            SizedBox(height: 15),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // PREDICT IMAGE
  // =========================

  Future<void> predictImage() async {
    if (imageBytes == null) return;
    if (isRequestRunning) return;

    isRequestRunning = true;
    setState(() => isLoading = true);
    startLoadingAnimation();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.193.220.176:8000/predict'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes!,
          filename: 'stroberi.jpg',
        ),
      );

      var response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);

        stopLoadingAnimation();
        setState(() {
          result = data['prediction'];
          confidence = data['confidence'].toDouble();
          isLoading = false;
          isSaved = false;
        });
        isRequestRunning = false;

      } else {
        stopLoadingAnimation();
        setState(() => isLoading = false);
        isRequestRunning = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("API Error")),
        );
      }

    } catch (e) {
      stopLoadingAnimation();
      setState(() => isLoading = false);
      isRequestRunning = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal terhubung ke AI Server"),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint(e.toString());
    }
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {

    Color resultColor = Colors.orange;
    if (result == "Matang") resultColor = primaryColor;
    else if (result == "Mentah") resultColor = Colors.green;
    else if (result == "Setengah Matang") resultColor = Colors.orange;

    bool isValidStroberi = confidence >= 60; // ← DIUBAH
    bool hasResult = result != "-" && !isLoading;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tingkat Kematangan Buah Stroberi",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Deteksi tingkat kematangan stroberi menggunakan Hybrid CNN & SVM.",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: isLoading ? null : showImagePickerOption,
                          child: const Text(
                            "Upload Gambar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // IMAGE PREVIEW
                if (imageBytes != null)
                  Stack(
                    children: [
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.memory(imageBytes!, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),

                if (imageBytes == null)
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 80, color: Colors.grey),
                        SizedBox(height: 15),
                        Text(
                          "Belum ada gambar",
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 30),

                // LOADING
                if (isLoading)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                            color: primaryColor,
                            backgroundColor: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          loadingTexts[loadingIndex],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        LinearProgressIndicator(
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor,
                          backgroundColor: Colors.grey.shade800,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Artificial Intelligence sedang bekerja...",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                // =========================
                // TIDAK TERDETEKSI CARD ← BARU
                // =========================

                if (hasResult && !isValidStroberi)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.orange, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.help_outline_rounded,
                          color: Colors.orange,
                          size: 70,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Tidak Terdeteksi",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Gambar yang diunggah bukan buah stroberi atau kualitas gambar kurang jelas. Silakan coba lagi dengan gambar stroberi yang lebih jelas.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: const BorderSide(color: Colors.orange, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: deteksiUlang,
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              "Coba Lagi",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // =========================
                // RESULT CARD ← DIUBAH
                // =========================

                if (hasResult && isValidStroberi)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // STATUS KEMATANGAN
                        const Text(
                          "STATUS KEMATANGAN",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Text(
                              result,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: resultColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: resultColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: resultColor, width: 1),
                              ),
                              child: Text(
                                getStatusLabel(),
                                style: TextStyle(
                                  color: resultColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // TINGKAT KEYAKINAN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tingkat Keyakinan AI",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${confidence.toStringAsFixed(1)}%",
                              style: TextStyle(
                                color: resultColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        LinearProgressIndicator(
                          value: confidence / 100,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(20),
                          backgroundColor: Colors.grey.shade800,
                          valueColor: AlwaysStoppedAnimation<Color>(resultColor),
                        ),

                        const SizedBox(height: 20),

                        // DESKRIPSI
                        if (result != "-")
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: resultColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: resultColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '"${getDescription()}"',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                height: 1.6,
                              ),
                            ),
                          ),

                        const SizedBox(height: 25),

                        // INDIKATOR PEMBANDING
                        const Text(
                          "Indikator Pembanding",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        _buildIndikator("Matang (Merah)", primaryColor, result == "Matang"),
                        const SizedBox(height: 10),
                        _buildIndikator("Setengah Matang (Kuning)", Colors.orange, result == "Setengah Matang"),
                        const SizedBox(height: 10),
                        _buildIndikator("Mentah (Hijau)", Colors.green, result == "Mentah"),

                        const SizedBox(height: 25),

                        // TOMBOL SIMPAN
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSaved ? Colors.grey.shade700 : Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: isSaved ? null : simpanKeRiwayat,
                            icon: Icon(isSaved ? Icons.check : Icons.save_alt),
                            label: Text(
                              isSaved ? "Tersimpan" : "Simpan ke Riwayat",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // TOMBOL DETEKSI ULANG
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white30, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: deteksiUlang,
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              "Deteksi Ulang",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // WIDGET INDIKATOR
  // =========================

  Widget _buildIndikator(String label, Color color, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? color : Colors.white12,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (isSelected)
            Icon(Icons.radio_button_checked, color: color, size: 20)
          else
            const Icon(Icons.radio_button_unchecked, color: Colors.white24, size: 20),
        ],
      ),
    );
  }
}