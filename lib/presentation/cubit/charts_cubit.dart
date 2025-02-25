import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../boundary/usecase/charts_usecase.dart';
import '../../domain/entity/point.dart';

part 'charts_state.dart';

class ChartsCubit extends Cubit<ChartsState> {
  final ChartsUseCase chartsUseCase;

  ChartsCubit({required this.chartsUseCase}) : super(ChartsInitial());

  void buildCharts(int numberChart, int countTerm) async {
    emit(ChartsLoading());
    final triangles = await chartsUseCase.buildTriangle(countTerm);
    emit(ChartsCreated(triangles));
  }

  void back() {
    emit(ChartsInitial());
  }
}
