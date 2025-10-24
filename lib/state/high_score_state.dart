import 'package:flutter/material.dart';
import 'package:magic_tile/service/high_score_service.dart';

class HighScoreState extends ChangeNotifier {
  int highScore = 0;
  bool isNewHighScore = false;
  Future<void> updateHighScore(int newScore) async {
    if(newScore>highScore){
      isNewHighScore = true;
      highScore = newScore;
      await HighScoreService.addHighScore(newScore: newScore);
    }else{
      isNewHighScore = false;
    }
    
   notifyListeners();
  }

  Future<int> getHighScore() async {
    highScore = await HighScoreService.getHighScore();
    notifyListeners();
    return highScore;
  }
}
