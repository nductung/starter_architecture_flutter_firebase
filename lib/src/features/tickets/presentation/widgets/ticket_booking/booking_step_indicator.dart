import 'package:flutter/material.dart';

class BookingStepIndicator extends StatelessWidget {
  const BookingStepIndicator({
    super.key,
    required this.currentStep,
  });

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 2,
                  color: i < currentStep
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                ),
              ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: i <= currentStep
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: i < currentStep
                    ? const Icon(
                        Icons.check,
                        color: Colors.indigo,
                        size: 16,
                      )
                    : Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: i == currentStep
                              ? Colors.indigo
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 