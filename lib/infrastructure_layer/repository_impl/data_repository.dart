import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_application_test1/models/MuscleData.dart'; // Generated by Amplify
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart' as domain;

class RealDataRepository {
  Future<List<domain.MuscleEntity>> fetchAllMuscles() async {
    try {
      // Create a GraphQL List query for MuscleData
      final request = ModelQueries.list(MuscleData.classType);
      final response = await Amplify.API.query(request: request).response;

      // Check if the query was successful and handle errors
      final muscleDataList = response.data?.items;
      if (muscleDataList == null) {
        print('fetchAllMuscles errors: ${response.errors}');
        return const [];
      }

      // Map the fetched models to the domain entities
      return muscleDataList.map((muscleData) {
        return domain.MuscleEntity(
          id: muscleData!.muscleId,
          name: muscleData.name,
        );
      }).toList();
    } on ApiException catch (e) {
      print('Query failed: $e');
      return [];
    }
  }
}
