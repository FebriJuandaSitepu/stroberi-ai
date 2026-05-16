import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_model.dart';
import '../data/history_data.dart';

class HistoryService {

  // =========================
  // SAVE HISTORY
  // =========================

  static Future<void> saveHistory() async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> historyJson = historyList
        .map(
          (item) =>
              jsonEncode(item.toJson()),
        )
        .toList();

    await prefs.setStringList(
      'history',
      historyJson,
    );
  }

  // =========================
  // LOAD HISTORY
  // =========================

  static Future<void> loadHistory() async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String>? historyJson =
        prefs.getStringList('history');

    if (historyJson != null) {

      historyList = historyJson
          .map(

            (item) => HistoryModel.fromJson(
              jsonDecode(item),
            ),
          )
          .toList();
    }
  }
}