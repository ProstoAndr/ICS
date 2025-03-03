import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../domain/entity/point.dart';

class MembershipTables extends StatelessWidget {
  final List<List<Point>> membershipData;
  const MembershipTables({super.key, required this.membershipData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: membershipData.asMap().entries.map((entry) {
        int termIndex = entry.key + 1;
        List<Point> points = entry.value;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Терм $termIndex",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Gap(4),
                Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        _buildTableCell("X"),
                        _buildTableCell("Принадлежность"),
                      ],
                    ),
                    ...points.map((p) => TableRow(
                      children: [
                        _buildTableCell(p.x.toStringAsFixed(2)),
                        _buildTableCell((p.y * 100).toStringAsFixed(1) + "%"),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Метод для создания ячеек таблицы
  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Center(child: Text(text, style: const TextStyle(fontSize: 12))),
    );
  }
}
