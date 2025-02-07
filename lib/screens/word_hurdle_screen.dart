import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_hurdle/app_provider.dart';
import 'package:word_hurdle/utils/helper_functions.dart';
import 'package:word_hurdle/widgets/keyboard_view.dart';
import 'package:word_hurdle/widgets/wordle_view.dart';

class WordHurdleScreen extends StatefulWidget {
  const WordHurdleScreen({super.key});

  @override
  State<WordHurdleScreen> createState() => _WordHurdleScreenState();
}

class _WordHurdleScreenState extends State<WordHurdleScreen> {
  @override
  void didChangeDependencies() {
    Provider.of<AppProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Hurdle'),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).reset();
            },
            child: const Text('RESET'),
          ),
          const SizedBox(width: 16),  
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Consumer<AppProvider>(
                  builder: (context, provider, child) => GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: provider.hurdleBoard.length,
                    itemBuilder: (context, index) {
                      final wordle = provider.hurdleBoard[index];
                      return WordleView(wordle: wordle);
                    },
                  ),
                ),
              ),
            ),
            Consumer<AppProvider>(
              builder: (context, provider, child) => KeyboardView(
                excludedLetters: provider.excludedLetters,
                onPressed: (value) {
                  provider.inputLetter(value);
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<AppProvider>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        provider.deleteLetter();
                      }, 
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('DELETE'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (provider.rowInputs.length < provider.lettersPerRow) {
                          null;
                        } else {
                          _handleInput(provider);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('SUBMIT'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleInput(AppProvider provider) {
    if (!provider.isValidWord) {
      showMessage(context, 'Invalid word...');
      return;
    }
    if (provider.shouldCheckAnswer) {
      provider.checkAnswer();
    }
    if (provider.playerWins) {
      showResult(
        context: context,
        title: 'You Win!',
        body: 'Congratulations! You have guessed the word!',
        onPlayAgain: () {
          Navigator.pop(context);
          provider.reset();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      );
    } else if (provider.noAttemptsLeft) {
      showResult(
        context: context,
        title: 'Game Over!',
        body: 'You didn\'t guess the word (${provider.targetWord}).\n\nWanna try again?',
        onPlayAgain: () {
          Navigator.pop(context);
          provider.reset();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      );
    }
  }
}