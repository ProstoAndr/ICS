part of 'rules_cubit.dart';

@immutable
sealed class RulesState {}

class RulesInitial extends RulesState {}

class RulesLoading extends RulesState {}

class RulesCreated extends RulesState {
  final String nameMethod;
  final String countTerm;
  final String countPlenty;
  final String countRules;

  RulesCreated({
    required this.nameMethod,
    required this.countTerm,
    required this.countPlenty,
    required this.countRules,
  });
}

class RulesError extends RulesState {}
