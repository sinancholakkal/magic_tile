import 'package:shared_preferences/shared_preferences.dart';

class HighScoreService {
  static const String _highScoreKey = 'high_score';

  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }
  static Future<void>addHighScore({required int newScore})async{
    final prefs = await SharedPreferences.getInstance();
    int  oldScore = prefs.getInt(_highScoreKey)??0;
    if(newScore > oldScore){
      await prefs.setInt(_highScoreKey, newScore);
    }
  }
  static Future<void>resetHighScore()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_highScoreKey);
  }
}