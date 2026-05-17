import 'package:flutter/material.dart';

import '../data/history_data.dart';
import '../models/history_model.dart';
import '../services/history_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  // =========================
  // APP COLORS
  // =========================

  static const Color primaryColor = Color(0xFFFF4B5C);
  static const Color backgroundColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF1A1A1A);

  String searchText = "";

  // =========================
  // FILTER HISTORY
  // =========================

 List<HistoryModel> get filteredHistory {
  if (searchText.isEmpty) return historyList;

  return historyList.where((item) {
    return item.result
        .trim()
        .toLowerCase()
        .startsWith(searchText.trim().toLowerCase());
  }).toList();
}

  // =========================
  // DELETE SINGLE HISTORY
  // =========================

  Future<void> deleteHistory(int index) async {
    historyList.removeAt(index);
    await HistoryService.saveHistory();
    setState(() {});
  }

  // =========================
  // DELETE ALL HISTORY
  // =========================

  Future<void> deleteAllHistory() async {
    historyList.clear();
    await HistoryService.saveHistory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: const Text(
          "Riwayat Deteksi",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              bool? confirm = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: cardColor,
                    title: const Text(
                      "Hapus Semua?",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      "Semua riwayat akan dihapus.",
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          "Batal",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Hapus"),
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) await deleteAllHistory();
            },
            icon: const Icon(Icons.delete_forever, color: Colors.white),
          ),
        ],
      ),

      body: Column(
        children: [

          // =========================
          // SEARCH BAR
          // =========================

          Padding(
  padding: const EdgeInsets.all(15),
  child: TextField(
    onChanged: (value) {
      setState(() {
        searchText = value;
      });
    },
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: "Cari hasil prediksi...",
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: const Icon(Icons.search, color: Colors.white70),
      filled: true,
      fillColor: primaryColor, // <-- ubah jadi merah
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
  ),
),

          // =========================
          // HISTORY LIST
          // =========================

          Expanded(
            child: filteredHistory.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada riwayat",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white54,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: filteredHistory.length,
                    itemBuilder: (context, index) {
                      HistoryModel item = filteredHistory[index];

                      Color resultColor = Colors.orange;
                      if (item.result == "Matang") {
                        resultColor = primaryColor;
                      } else if (item.result == "Mentah") {
                        resultColor = Colors.green;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white10,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [

                            // IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: item.imageBytes != null
                                  ? Image.memory(
                                      item.imageBytes!,
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 110,
                                      height: 110,
                                      color: Colors.grey.shade800,
                                      child: const Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.white54,
                                      ),
                                    ),
                            ),

                            const SizedBox(width: 20),

                            // TEXT
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.result,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: resultColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Confidence: ${item.confidence.toStringAsFixed(2)}%",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item.createdAt.toString(),
                                    style: const TextStyle(
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // DELETE BUTTON
                            IconButton(
                              onPressed: () async {
                                await deleteHistory(index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}