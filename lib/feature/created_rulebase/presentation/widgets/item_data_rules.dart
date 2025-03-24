import 'package:flutter/material.dart';
import 'package:ics/theme/main_colors.dart';

class ItemDataRules extends StatelessWidget {
  final String parameter;
  const ItemDataRules({super.key, required this.parameter});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF6A4BA3), width: 2),
          ),
          child: Center(
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFF6A4BA3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(parameter, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
