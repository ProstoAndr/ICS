import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';

import '../../boudary/usecase/model_training_usecase.dart';

part 'model_training_state.dart';

class ModelTrainingCubit extends Cubit<ModelTrainingState> {
  final ModelTrainingUseCase modelTrainingUseCase;

  ModelTrainingCubit({
    required this.modelTrainingUseCase,
  }) : super(ModelTrainingInitial());

  Future<void> training(List<Rule> listRule, double singleton) async {
    emit(ModelTrainingLoading());
    await modelTrainingUseCase.gradientDescent(listRule, singleton);
    emit(ModelTrainingCreated());
  }
}
