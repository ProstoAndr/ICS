import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/chart_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';

import '../../boudary/usecase/model_training_usecase.dart';

part 'model_training_state.dart';

class ModelTrainingCubit extends Cubit<ModelTrainingState> {
  final ModelTrainingUseCase modelTrainingUseCase;

  ModelTrainingCubit({
    required this.modelTrainingUseCase,
  }) : super(ModelTrainingInitial());

  late List<Rule> updatedRules;

  Future<void> training(
    List<Rule> listRule,
    List<Plenty> plenties,
    List<ChartData> membershipAll,
  ) async {
    emit(ModelTrainingLoading());

    await Future.delayed(Duration.zero);

    final newRules = await modelTrainingUseCase.modelTraining(
      listPlenty: plenties,
      listChartData: membershipAll,
      listRule: listRule,
    );

    updatedRules = newRules;
    emit(ModelTrainingCreated(updatedRules: updatedRules));
  }

  Future<void> predictTSK(
    List<Rule> listRule,
    List<Plenty> plenties,
    List<ChartData> membershipAll,
  ) async {
    final predictTSK = await modelTrainingUseCase.predictTSK(
      listPlenty: plenties,
      listChartData: membershipAll,
      listRule: listRule,
    );
    debugPrint("MSE: $predictTSK");
  }
}
