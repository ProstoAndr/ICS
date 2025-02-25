part of 'charts_cubit.dart';

@immutable
sealed class ChartsState {}

class ChartsInitial extends ChartsState {}

class ChartsLoading extends ChartsState {}

class ChartsCreated extends ChartsState {
  final List<List<Point>> triangles;

  ChartsCreated(this.triangles);
}
