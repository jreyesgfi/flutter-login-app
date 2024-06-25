import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/services/training_data_transformer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_list_selector.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_carousel_selector.dart';

class TrainingSelectionSubscreen extends StatelessWidget {
  TrainingSelectionSubscreen({Key? super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Accessing provider to get muscles and exercises
    final muscles = Provider.of<TrainingScreenProvider>(context).allMuscles;
    final exercises = Provider.of<TrainingScreenProvider>(context).filteredExercises; // Assuming this is filtered based on selected muscle

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 30),
            child: Text(
              "¿Qué vamos a entrenar hoy?",
              style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
            ),
          ),
          // Display muscle carousel selector if muscles are available
          if (muscles.isNotEmpty)
            MuscleCarouselSelector(muscles:  TrainingDataTransformer.transformMusclesToTiles(muscles)),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 30),
            child: Text(
              "Escoge un ejercicio",
              style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
            ),
          ),
          // Display exercise list selector if exercises are available
          if (exercises.isNotEmpty)
            ExerciseListSelector(exercises: TrainingDataTransformer.transformExercisesToTiles(exercises)),
        ],
      ),
    );
  }
}
