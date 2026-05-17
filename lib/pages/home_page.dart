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
    State<HomePage> createState() =>
        _HomePageState();
  }

  class _HomePageState
      extends State<HomePage> {

    // =========================
    // APP COLORS
    // =========================

    static const Color primaryColor =
        Color(0xFFFF4B5C);

    static const Color secondaryColor =
        Color(0xFFFF6B6B);

    static const Color backgroundColor =
        Color(0xFF0A0A0A);

    static const Color cardColor =
        Color(0xFF1A1A1A);

    // =========================
    // VARIABLES
    // =========================

    final ImagePicker picker =
        ImagePicker();

    XFile? imageFile;

    Uint8List? imageBytes;

    String result = "-";

    double confidence = 0;

    bool isLoading = false;

    bool isRequestRunning = false;

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

            if (loadingIndex >=
                loadingTexts.length) {

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

    Future<void> pickImage(
      ImageSource source,
    ) async {

      final pickedFile =
          await picker.pickImage(

        source: source,

        imageQuality: 85,
      );

      if (pickedFile != null) {

        final bytes =
            await pickedFile.readAsBytes();

        setState(() {

          imageFile = pickedFile;

          imageBytes = bytes;

          result = "-";

          confidence = 0;
        });

        await predictImage();
      }
    }

    // =========================
    // IMAGE PICKER OPTION
    // =========================

    void showImagePickerOption() {

      showModalBottomSheet(

        context: context,

        backgroundColor:
            const Color(0xFF1A1A1A),

        shape:
            const RoundedRectangleBorder(

          borderRadius:
              BorderRadius.vertical(

            top: Radius.circular(30),
          ),
        ),

        builder: (context) {

          return Padding(

            padding:
                const EdgeInsets.all(25),

            child: Column(

              mainAxisSize:
                  MainAxisSize.min,

              children: [

                Container(

                  width: 60,

                  height: 6,

                  decoration: BoxDecoration(

                    color:
                        Colors.grey.shade700,

                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(

                  "Pilih Gambar",

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 24,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Row(

                  children: [

                    Expanded(

                      child: GestureDetector(

                        onTap: () {

                          Navigator.pop(
                            context,
                          );

                          pickImage(
                            ImageSource.camera,
                          );
                        },

                        child: Container(

                          padding:
                              const EdgeInsets
                                  .all(25),

                          decoration:
                              BoxDecoration(

                            color:
                                primaryColor
                                    .withOpacity(
                                        0.1),

                            borderRadius:
                                BorderRadius
                                    .circular(
                                        25),
                          ),

                          child: const Column(

                            children: [

                              Icon(

                                Icons
                                    .camera_alt,

                                size: 50,

                                color:
                                    primaryColor,
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              Text(

                                "Kamera",

                                style:
                                    TextStyle(

                                  color:
                                      Colors
                                          .white,

                                  fontSize:
                                      18,

                                  fontWeight:
                                      FontWeight
                                          .bold,
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

                          Navigator.pop(
                            context,
                          );

                          pickImage(
                            ImageSource.gallery,
                          );
                        },

                        child: Container(

                          padding:
                              const EdgeInsets
                                  .all(25),

                          decoration:
                              BoxDecoration(

                            color:
                                secondaryColor
                                    .withOpacity(
                                        0.1),

                            borderRadius:
                                BorderRadius
                                    .circular(
                                        25),
                          ),

                          child: const Column(

                            children: [

                              Icon(

                                Icons.image,

                                size: 50,

                                color:
                                    secondaryColor,
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              Text(

                                "Gallery",

                                style:
                                    TextStyle(

                                  color:
                                      Colors
                                          .white,

                                  fontSize:
                                      18,

                                  fontWeight:
                                      FontWeight
                                          .bold,
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

      setState(() {

        isLoading = true;
      });

      startLoadingAnimation();

      try {

        var request = http.MultipartRequest(
  'POST',
  Uri.parse('http://10.143.45.176:8000/predict'), 
);

        request.files.add(

          http.MultipartFile.fromBytes(

            'file',

            imageBytes!,

            filename: 'stroberi.jpg',
          ),
        );

        var response =
            await request.send().timeout(

          const Duration(seconds: 15),
        );

        if (response.statusCode == 200) {

          final responseData =
              await response.stream
                  .bytesToString();

          final data =
              json.decode(responseData);

          stopLoadingAnimation();

          setState(() {

            result = data['prediction'];

            confidence =
                data['confidence']
                    .toDouble();

            isLoading = false;
          });

          isRequestRunning = false;

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

        } else {

          stopLoadingAnimation();

          setState(() {

            isLoading = false;
          });

          isRequestRunning = false;

          ScaffoldMessenger.of(context)
              .showSnackBar(

            const SnackBar(

              content:
                  Text("API Error"),
            ),
          );
        }

      } catch (e) {

        stopLoadingAnimation();

        setState(() {

          isLoading = false;
        });

        isRequestRunning = false;

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Gagal terhubung ke AI Server",
            ),

            backgroundColor:
                Colors.red,
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

      Color resultColor =
          Colors.orange;

      if (result == "Matang") {

        resultColor = primaryColor;

      } else if (result ==
          "Mentah") {

        resultColor = Colors.green;
      }

      bool isValidStroberi =
          confidence >= 60 ||
              result == "-";

      return Scaffold(

        backgroundColor:
            backgroundColor,

        body: SafeArea(

          child: SingleChildScrollView(

            child: Padding(

              padding:
                  const EdgeInsets.all(
                      20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  // HEADER

                  Container(

                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets
                            .all(25),

                    decoration:
                        BoxDecoration(

                      gradient:
                          const LinearGradient(

                        begin:
                            Alignment
                                .topLeft,

                        end:
                            Alignment
                                .bottomRight,

                        colors: [

                          primaryColor,

                          secondaryColor,
                        ],
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(
                                  30),
                    ),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        const Text(

                          "Tingkat Kematangan Buah Stroberi",

                          style:
                              TextStyle(

                            color:
                                Color.fromARGB(255, 0, 0, 0),

                            fontSize:
                                30,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        const Text(
  "Deteksi tingkat kematangan stroberi menggunakan Hybrid CNN & SVM.",
  style: TextStyle(
    color: Color.fromARGB(255, 0, 0, 0),
    fontSize: 16,
  ),
),

const SizedBox(height: 25), // <-- TAMBAHKAN INI

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

                          child:
                              ElevatedButton(

                            style:
                                ElevatedButton
                                    .styleFrom(

                              backgroundColor:
                                       primaryColor,

                              foregroundColor:
                                  Colors.black,

                              elevation:
                                  0,

                              shape:
                                  RoundedRectangleBorder(

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            18),
                              ),
                            ),

                            onPressed:
                                isLoading
                                    ? null
                                    : showImagePickerOption,

                            child:
                                const Text(

                              "Upload Gambar",

                              style:
                                  TextStyle(

                                fontSize:
                                    18,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 30),

                  // IMAGE PREVIEW

                  Container(

                    height: 280,

                    width:
                        double.infinity,

                    decoration:
                        BoxDecoration(

                      color:
                          cardColor,

                      borderRadius:
                          BorderRadius
                              .circular(
                                  30),

                      boxShadow: [

                        BoxShadow(

                          color: Colors
                              .black
                              .withOpacity(
                                  0.15),

                          blurRadius:
                              10,

                          offset:
                              const Offset(
                                  0, 5),
                        ),
                      ],
                    ),

                    child:
                        imageBytes == null

                            ? const Column(

                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,

                                children: [

                                  Icon(

                                    Icons.image,

                                    size: 80,

                                    color: Colors
                                        .grey,
                                  ),

                                  SizedBox(
                                    height:
                                        15,
                                  ),

                                  Text(

                                    "Belum ada gambar",

                                    style:
                                        TextStyle(

                                      fontSize:
                                          18,

                                      color:
                                          Colors
                                              .white70,
                                    ),
                                  ),
                                ],
                              )

                            : ClipRRect(

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            30),

                                child:
                                    Image.memory(

                                  imageBytes!,

                                  fit: BoxFit
                                      .cover,
                                ),
                              ),
                  ),

                  const SizedBox(
                      height: 30),

                  // LOADING

                  if (isLoading)

                    Container(

                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets
                              .all(25),

                      decoration:
                          BoxDecoration(

                        color:
                            cardColor,

                        borderRadius:
                            BorderRadius
                                .circular(
                                    30),

                        boxShadow: [

                          BoxShadow(

                            color: Colors
                                .black
                                .withOpacity(
                                    0.15),

                            blurRadius:
                                10,

                            offset:
                                const Offset(
                                    0, 5),
                          ),
                        ],
                      ),

                      child: Column(

                        children: [

                          SizedBox(

                            width: 70,

                            height: 70,

                            child:
                                CircularProgressIndicator(

                              strokeWidth:
                                  6,

                              color:
                                  primaryColor,

                              backgroundColor:
                                  Colors
                                      .grey
                                      .shade800,
                            ),
                          ),

                          const SizedBox(
                              height: 30),

                          Text(

                            loadingTexts[
                                loadingIndex],

                            textAlign:
                                TextAlign
                                    .center,

                            style:
                                const TextStyle(

                              color:
                                  Colors
                                      .white,

                              fontSize:
                                  18,

                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),

                          const SizedBox(
                              height: 20),

                          LinearProgressIndicator(

                            minHeight:
                                10,

                            borderRadius:
                                BorderRadius
                                    .circular(
                                        20),

                            color:
                                primaryColor,

                            backgroundColor:
                                Colors
                                    .grey
                                    .shade800,
                          ),

                          const SizedBox(
                              height: 15),

                          const Text(

                            "Artificial Intelligence sedang bekerja...",

                            style:
                                TextStyle(

                              color:
                                  Colors
                                      .white70,

                              fontSize:
                                  14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(
                      height: 30),

                  // RESULT CARD

                  Container(

                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets
                            .all(25),

                    decoration:
                        BoxDecoration(

                      color:
                          cardColor,

                      borderRadius:
                          BorderRadius
                              .circular(
                                  30),

                      boxShadow: [

                        BoxShadow(

                          color: Colors
                              .black
                              .withOpacity(
                                  0.15),

                          blurRadius:
                              10,

                          offset:
                              const Offset(
                                  0, 5),
                        ),
                      ],
                    ),

                    child: Column(

                      children: [

                        const Text(

                          "Hasil Prediksi",

                          style:
                              TextStyle(

                            color:
                                Colors
                                    .white,

                            fontSize:
                                24,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                            height: 25),

                        if (!isValidStroberi)

                          Container(

                            width:
                                double.infinity,

                            padding:
                                const EdgeInsets
                                    .all(15),

                            decoration:
                                BoxDecoration(

                              color: Colors
                                  .orange
                                  .withOpacity(
                                      0.1),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          15),

                              border:
                                  Border.all(

                                color: Colors
                                    .orange,

                                width: 1,
                              ),
                            ),

                            child:
                                const Row(

                              children: [

                                Icon(

                                  Icons
                                      .warning_amber,

                                  color:
                                      Colors
                                          .orange,

                                  size: 30,
                                ),

                                SizedBox(
                                    width:
                                        10),

                                Expanded(

                                  child:
                                      Text(

                                    "Gambar tidak terdeteksi sebagai stroberi. Gunakan gambar stroberi yang jelas!",

                                    style:
                                        TextStyle(

                                      color:
                                          Colors.orange,

                                      fontSize:
                                          14,

                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (!isValidStroberi)
                          const SizedBox(
                              height: 20),

                        Text(

                          isValidStroberi
                              ? result
                              : "Tidak Dikenali",

                          style:
                              TextStyle(

                            fontSize:
                                38,

                            fontWeight:
                                FontWeight
                                    .bold,

                            color:
                                isValidStroberi
                                    ? resultColor
                                    : Colors.orange,
                          ),
                        ),

                        const SizedBox(
                            height: 25),

                        LinearProgressIndicator(

                          value:
                              confidence /
                                  100,

                          minHeight:
                              15,

                          borderRadius:
                              BorderRadius
                                  .circular(
                                      20),

                          backgroundColor:
                              Colors.grey
                                  .shade800,

                          valueColor:
                              AlwaysStoppedAnimation<
                                  Color>(

                            isValidStroberi
                                ? resultColor
                                : Colors.orange,
                          ),
                        ),

                        const SizedBox(
                            height: 15),

                        Text(

                          "${confidence.toStringAsFixed(2)}% Confidence",

                          style:
                              const TextStyle(

                            color:
                                Colors
                                    .white,

                            fontSize:
                                18,

                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 30),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

