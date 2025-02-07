import 'package:flutter/material.dart';

const keysList = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
];

class KeyboardView extends StatelessWidget {
  final List<String> excludedLetters;
  final Function(String) onPressed;
  
  const KeyboardView({
    super.key,
    required this.excludedLetters,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          spacing: 4,
          children: [
            for (int i = 0; i < keysList.length; i++)
              Row(
                spacing: 2,
                children: keysList[i].map((e) => VirtualKey(
                  letter: e,
                  excluded: excludedLetters.contains(e),
                  onPressed: (value) {
                    onPressed(value);
                  },
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class VirtualKey extends StatelessWidget {
  final String letter;
  final bool excluded;
  final Function(String) onPressed;
  
  const VirtualKey({
    super.key,
    required this.letter,
    this.excluded = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          onPressed(letter);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: excluded ? Colors.red.shade900 : Colors.black,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(letter),
        ),
      ),
    );
  }
}