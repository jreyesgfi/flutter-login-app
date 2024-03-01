import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_test1/models/muscles_and_exercises.dart';
import 'package:flutter_application_test1/screens/main_screen.dart';
import 'package:flutter_application_test1/theme/custom_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_test1/models/Exercise.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_application_test1/theme/components/roulette_numeric_input.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onDeleteSuccess;

  ExerciseCard({
    Key? key,
    required this.exercise,
    required this.onDeleteSuccess,
  }) : super(key: key);

  void _deleteEntry(BuildContext context) async {
    try {
      await Amplify.DataStore.delete(exercise);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entry deleted successfully!')),
      );
      onDeleteSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting entry: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1), // Use theme for color
        borderRadius: BorderRadius.circular(4), // Same rounded corner as Card
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${exercise.exercise}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                SizedBox(height: 4), // Adjust spacing
                Text(
                    "${DateFormat('yyyy-MM-dd').format(exercise.date.getDateTime())}",
                    style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 8), // Adjust spacing for visual separation
                Text("Weight: ${exercise.maxWeight} / ${exercise.minWeight}",
                    style: TextStyle(fontSize: 16.0)),
                Text("Reps: ${exercise.maxReps} / ${exercise.minReps}",
                    style: TextStyle(fontSize: 16.0)),
                // Additional exercise details can be added here as needed
              ],
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: IconButton(
                icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
                onPressed: () => _deleteEntry(
                    context), // Ensure this method is defined to accept BuildContext
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditableExerciseCard extends StatefulWidget {
  final String userId;
  final VoidCallback onPublishSuccess;

  EditableExerciseCard({
    Key? key,
    required this.userId,
    required this.onPublishSuccess,
  }) : super(key: key);

  @override
  _EditableExerciseCardState createState() => _EditableExerciseCardState();
}

class _EditableExerciseCardState extends State<EditableExerciseCard> {
  late TextEditingController _exerciseController;
  late TextEditingController _maxWeightController;
  late TextEditingController _minWeightController;
  late TextEditingController _maxRepsController;
  late TextEditingController _minRepsController;


  String? _selectedExercise;

  @override
  void initState() {
    super.initState();
    _exerciseController = TextEditingController(text: '');
    _maxWeightController = TextEditingController(text: '0');
    _minWeightController = TextEditingController(text: '0');
    _maxRepsController = TextEditingController(text: '0');
    _minRepsController = TextEditingController(text: '0');
  }

  void _publishEntry(context) async {
    final staticModel =
        Provider.of<MuscleDateSelectionModel>(context, listen: false);
    final selectedMuscle = staticModel.selectedMuscle;
    final selectedDate = staticModel.selectedDate;

    // Assuming you have a method to create or update the exercise
    final newExercise = Exercise(
      updatedAt: TemporalDateTime.now(),
      userId: widget.userId,
      date: TemporalDate(selectedDate),
      muscle: selectedMuscle,
      exercise: _selectedExercise!,
      maxWeight: double.tryParse(_maxWeightController.text),
      minWeight: double.tryParse(_minWeightController.text),
      maxReps: int.tryParse(_maxRepsController.text),
      minReps: int.tryParse(_minRepsController.text),
    );

    try {
      await Amplify.DataStore.save(newExercise);
      widget.onPublishSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error publishing entry: $e')));
    }
  }

  //dispose the controllers
  @override
  void dispose() {
    _exerciseController.dispose();
    _maxWeightController.dispose();
    _minWeightController.dispose();
    _maxRepsController.dispose();
    _minRepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget exerciseDropdown() {
      return Consumer<MuscleDateSelectionModel>(
        builder: (context, model, child) {
          List<String>? muscleExercises = exercisesByMuscle[model.selectedMuscle];
          bool shouldShow =
              model.selectedMuscle.isNotEmpty && muscleExercises != null;

          // Ensure _selectedExercise is valid for the current muscle
          if (muscleExercises== null || !muscleExercises.contains(_selectedExercise)) {
            _selectedExercise = null;
          }

          return shouldShow
              ? DropdownButtonFormField<String>(
                  value: _selectedExercise,
                  onChanged: (value) {
                    setState(() {
                      _selectedExercise = value;
                    });
                  },
                  items: muscleExercises.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: "Exercise"),
                )
              : Container();
        },
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1), // Main color border
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  exerciseDropdown(),
                  NumericRoulettePicker(
                    label: "Max Weight",
                    controller: _maxWeightController,
                    allowDecimal: true,
                  ),
                  NumericRoulettePicker(
                    label: "Min Weight",
                    controller: _minWeightController,
                    allowDecimal: true,
                  ),
                  NumericRoulettePicker(
                    label: "Max Reps",
                    controller: _maxRepsController,
                  ),
                  NumericRoulettePicker(
                    label: "Min Reps",
                    controller: _minRepsController,
                  )
                ],
              ),
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: Row(
                children: [
                  // Save button as an icon button
                  IconButton(
                    icon: Icon(Icons.file_download_done,
                        color: Theme.of(context).primaryColor),
                    onPressed: () => _publishEntry(context),
                  ),
                  // Assuming onDelete is defined similarly for EditableExerciseCard
                  // IconButton for delete (if applicable)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
