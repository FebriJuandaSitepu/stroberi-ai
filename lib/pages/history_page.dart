import 'package:flutter/material.dart';

import '../data/history_data.dart';
import '../models/history_model.dart';
import '../services/history_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() =>
      _HistoryPageState();
}

class _HistoryPageState
    extends State<HistoryPage> {

  String searchText = "";

  // =========================
  // FILTER HISTORY
  // =========================

  List<HistoryModel> get filteredHistory {

    if (searchText.isEmpty) {
      return historyList;
    }

    return historyList.where((item) {

      return item.result
          .toLowerCase()
          .contains(
            searchText.toLowerCase(),
          );
    }).toList();
  }

  // =========================
  // DELETE SINGLE HISTORY
  // =========================

  Future<void> deleteHistory(
    int index,
  ) async {

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

      backgroundColor: const Color(
        0xFFF6F6F6,
      ),

      appBar: AppBar(

        title: const Text(
          "Riwayat Deteksi",
        ),

        centerTitle: true,

        backgroundColor: Colors.redAccent,

        actions: [

          IconButton(

            onPressed: () async {

              bool? confirm =
                  await showDialog(

                context: context,

                builder: (context) {

                  return AlertDialog(

                    title: const Text(
                      "Hapus Semua?",
                    ),

                    content: const Text(
                      "Semua riwayat akan dihapus.",
                    ),

                    actions: [

                      TextButton(

                        onPressed: () {

                          Navigator.pop(
                            context,
                            false,
                          );
                        },

                        child: const Text(
                          "Batal",
                        ),
                      ),

                      ElevatedButton(

                        onPressed: () {

                          Navigator.pop(
                            context,
                            true,
                          );
                        },

                        child: const Text(
                          "Hapus",
                        ),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {

                await deleteAllHistory();
              }
            },

            icon: const Icon(
              Icons.delete_forever,
            ),
          ),
        ],
      ),

      body: Column(

        children: [

          // =========================
          // SEARCH BAR
          // =========================

          Padding(

            padding:
                const EdgeInsets.all(15),

            child: TextField(

              onChanged: (value) {

                setState(() {

                  searchText = value;
                });
              },

              decoration: InputDecoration(

                hintText:
                    "Cari hasil prediksi...",

                prefixIcon: const Icon(
                  Icons.search,
                ),

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

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
                      ),
                    ),
                  )

                : ListView.builder(

                    padding:
                        const EdgeInsets.all(
                      15,
                    ),

                    itemCount:
                        filteredHistory.length,

                    itemBuilder:
                        (context, index) {

                      HistoryModel item =
                          filteredHistory[index];

                      Color resultColor =
                          Colors.orange;

                      if (item.result ==
                          "Matang") {

                        resultColor =
                            Colors.redAccent;

                      } else if (item.result ==
                          "Mentah") {

                        resultColor =
                            Colors.green;
                      }

                      return Container(

                        margin:
                            const EdgeInsets.only(
                          bottom: 20,
                        ),

                        padding:
                            const EdgeInsets.all(
                          15,
                        ),

                        decoration:
                            BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            25,
                          ),

                          boxShadow: [

                            BoxShadow(

                              color: Colors.black
                                  .withOpacity(
                                0.05,
                              ),

                              blurRadius: 10,

                              offset:
                                  const Offset(
                                0,
                                5,
                              ),
                            ),
                          ],
                        ),

                        child: Row(

                          children: [

                            // IMAGE

                            ClipRRect(

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),

                              child:
                                  Image.network(

                                item.imagePath,

                                width: 110,

                                height: 110,

                                fit: BoxFit.cover,

                                errorBuilder:
                                    (
                                  context,
                                  error,
                                  stackTrace,
                                ) {

                                  return Container(

                                    width: 110,

                                    height: 110,

                                    color: Colors
                                        .grey
                                        .shade300,

                                    child:
                                        const Icon(
                                      Icons.image,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              width: 20,
                            ),

                            // TEXT

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Text(

                                    item.result,

                                    style:
                                        TextStyle(

                                      fontSize:
                                          28,

                                      fontWeight:
                                          FontWeight
                                              .bold,

                                      color:
                                          resultColor,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Text(

                                    "Confidence: ${item.confidence.toStringAsFixed(2)}%",

                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Text(

                                    item.createdAt
                                        .toString(),

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors
                                              .grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // DELETE BUTTON

                            IconButton(

                              onPressed:
                                  () async {

                                await deleteHistory(
                                  index,
                                );
                              },

                              icon: const Icon(

                                Icons.delete,

                                color:
                                    Colors.red,
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