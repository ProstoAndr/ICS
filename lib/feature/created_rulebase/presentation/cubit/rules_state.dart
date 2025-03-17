part of 'rules_cubit.dart';

@immutable
sealed class RulesState {}

class RulesInitial extends RulesState {}

class RulesLoading extends RulesState {}

class RulesCreated extends RulesState {
}

class RulesError extends RulesState {}