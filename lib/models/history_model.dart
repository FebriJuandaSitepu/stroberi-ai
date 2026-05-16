
import 'dart:typed_data';

class HistoryModel {

  final String result;

  final double confidence;

  final String imagePath;

  final DateTime createdAt;

  final Uint8List? imageBytes;

  HistoryModel({

    required this.result,

    required this.confidence,

    required this.imagePath,

    required this.createdAt,

    this.imageBytes,
  });

  Map<String, dynamic> toJson() {

    return {

      'result': result,

      'confidence': confidence,

      'imagePath': imagePath,

      'createdAt':
          createdAt.toIso8601String(),
    };
  }

  factory HistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return HistoryModel(

      result: json['result'],

      confidence:
          json['confidence'],

      imagePath:
          json['imagePath'],

      createdAt: DateTime.parse(
        json['createdAt'],
      ),
    );
  }
}
