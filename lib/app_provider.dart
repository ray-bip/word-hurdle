import 'dart:math';

import 'package:flutter/material.dart';
import 'package:word_hurdle/wordle.dart';
import 'package:english_words/english_words.dart' as words;

class AppProvider extends ChangeNotifier {
  final random = Random.secure();
  List<String> totalWords = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  List<Wordle> hurdleBoard = [];
  String targetWord = '';
  int count = 0;
  int index = 0;
  final lettersPerRow = 5;
  final totalAttempts = 6;
  int attempts = 0;
  bool playerWins = false;

  void init() {
    totalWords = words.all.where((element) => element.length == 5).toList();
    generateBoard();
    generateRandomWord();
  }

  void generateBoard() {
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ''));
  }

  void generateRandomWord() {
    targetWord = totalWords[random.nextInt(totalWords.length)].toUpperCase();
    print(targetWord);
  }

  bool get isValidWord {
    // return rowInputs.join() == targetWord; // AI says this, tutorial says code below
    return totalWords.contains(rowInputs.join('').toLowerCase());
  }

  bool get shouldCheckAnswer => rowInputs.length == lettersPerRow;

  bool get noAttemptsLeft => attempts == totalAttempts;

  void inputLetter(String letter) {
    if (count < lettersPerRow) {
      rowInputs.add(letter);
      count++;
      hurdleBoard[index] = Wordle(letter: letter);
      index++;
      notifyListeners();
    }
  }

  void deleteLetter() {
    if (rowInputs.isNotEmpty) {
      rowInputs.removeLast();
      hurdleBoard[index - 1] = Wordle(letter: '');
      count--;
      index--;
      notifyListeners();
    }
  }

  void checkAnswer() {
    final input = rowInputs.join('');
    if (targetWord == input) {
      playerWins = true;
    } else {
      _markLettersOnKeyboard();
      if (attempts < totalAttempts) {
        _goToNextRow();
      }
    }
  }
  
  void _markLettersOnKeyboard() {
    for (int i = 0; i < hurdleBoard.length; i++) {
      if (hurdleBoard[i].letter.isNotEmpty &&
        targetWord.contains(hurdleBoard[i].letter)) {
          hurdleBoard[i].existsInTarget = true;
      } else if (hurdleBoard[i].letter.isNotEmpty &&
        !targetWord.contains(hurdleBoard[i].letter)) {
          hurdleBoard[i].doesNotExistInTarget = true;
          excludedLetters.add(hurdleBoard[i].letter);
      }
    }
    notifyListeners();  
  }
  
  void _goToNextRow() {
    attempts++;
    count = 0;
    rowInputs.clear();
  }

  void reset() {
    count = 0;
    index = 0;
    attempts = 0;
    playerWins = false;
    rowInputs.clear();
    excludedLetters.clear();
    hurdleBoard.clear();
    targetWord = '';
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }

}