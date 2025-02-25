import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ics/presentation/cubit/charts_cubit.dart';
import 'package:ics/theme/MainColors.dart';

class CreatedCharts extends StatelessWidget {
  const CreatedCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartsCubit, ChartsState>(
      builder: (context, state) {
        if (state is ChartsCreated) {
          return Wrap(
            spacing: 16, // Отступ между графиками по горизонтали
            runSpacing: 16, // Отступ между графиками по вертикали
            children: state.chartData.map((chartData) {
              return Container(
                decoration: BoxDecoration(
                  color: MainColors.neutral010,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width:  840 - 32 - 16,
                        height: 256 - 32 - 16, // Оригинальная высота графика
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 32,
                                  getTitlesWidget: (value, meta) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Text(
                                        value.toStringAsFixed(1),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(value.toStringAsFixed(2)),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: chartData.data.map((triangle) {
                              return LineChartBarData(
                                spots: triangle.map((p) => FlSpot(p.x, p.y)).toList(),
                                isCurved: false,
                                barWidth: 2,
                                isStrokeCapRound: false,
                                belowBarData: BarAreaData(show: false),
                                color: Colors.blue,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8), // Отступ между графиком и названием
                      Text(
                        chartData.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
        return const Center(child: Text("Нет данных"));
      },
    );
  }
}
