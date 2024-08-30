import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart' as domain;
import 'package:flutter_application_test1/domain_layer/repositories/cloud_repository_interfaces.dart';
import 'package:flutter_application_test1/infrastructure_layer/network/muscle_data_service.dart';
import 'package:flutter_application_test1/models/MuscleData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final muscleRepositoryProvider = Provider<MuscleRepository>((ref) {
  final muscleService = ref.read(muscleDataServiceProvider);
  return MuscleRepositoryImpl(muscleService);
});

class MuscleRepositoryImpl implements MuscleRepository {
  final MuscleDataService muscleService;

  MuscleRepositoryImpl(this.muscleService);

  @override
  Future<List<domain.MuscleEntity>> fetchAllMuscles() async {
    List<MuscleData> muscleDataList = await muscleService.fetchAllMuscles();
    return muscleDataList.map((muscleData) {
      // Convert MuscleData from API to domain entity MuscleData
      return domain.MuscleEntity(
        id: muscleData.muscleId, // Ensure these field names match your domain model
        name: muscleData.name,
      );
    }).toList();
  }
}
