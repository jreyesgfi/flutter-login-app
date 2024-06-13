import 'package:flutter/material.dart';
import './exercise_tile.dart';

class ExerciseListSelector extends StatefulWidget {
  final List<ExerciseTileSchema> exercises;

  const ExerciseListSelector({
    super.key,
    required this.exercises,
  });

  @override
  _ExerciseListSelectorState createState() => _ExerciseListSelectorState();
}

class _ExerciseListSelectorState extends State<ExerciseListSelector> {
  int? selectedIndex;
  Map<int, bool> completionStatus =
      {}; // Tracks completion status by exercise index

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          widget.exercises.length,
          (index) {
            bool isCompleted =
                completionStatus[index] ?? false; // Default to false if not set
            return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    // Optionally toggle completion on tap or handle differently
                    completionStatus[index] = !isCompleted;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: index == 0 ? 10 : 0, bottom: 10),
                  child: ExerciseTile(
                    exercise: widget.exercises[index],
                    isSelected: selectedIndex == index,
                    isCompleted: isCompleted,
                  ),
                ));
          },
        ),
      ),
    );
  }
}