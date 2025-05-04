part of 'model_training_cubit.dart';

@immutable
sealed class ModelTrainingState {}

class ModelTrainingInitial extends ModelTrainingState {}

class ModelTrainingLoading extends ModelTrainingState {}

class ModelTrainingCreated extends ModelTrainingState {
  final List<Rule> updatedRules;

  ModelTrainingCreated({required this.updatedRules});
}

class RulesError extends ModelTrainingState {}
