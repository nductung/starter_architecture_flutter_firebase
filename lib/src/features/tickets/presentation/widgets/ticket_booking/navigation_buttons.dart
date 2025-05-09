import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({
    super.key,
    required this.onPrevious,
    required this.onNext,
    this.nextButtonText = 'Tiếp tục',
    this.previousButtonText = 'Quay lại',
    this.nextButtonIcon = Icons.arrow_forward_rounded,
    this.previousButtonIcon = Icons.arrow_back_rounded,
  });

  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String nextButtonText;
  final String previousButtonText;
  final IconData nextButtonIcon;
  final IconData previousButtonIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use a column layout on very small devices
          // if (constraints.maxWidth < 300) {
            return Column(
              children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nextButtonText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(nextButtonIcon, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onPrevious,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          previousButtonIcon,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          previousButtonText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          // }
          // Use row layout for normal sized devices
          // return Row(
          //   children: [
          //     Expanded(
          //       child: SizedBox(
          //         height: 50,
          //         child: OutlinedButton(
          //           onPressed: onPrevious,
          //           style: OutlinedButton.styleFrom(
          //             foregroundColor: Theme.of(context).primaryColor,
          //             side: BorderSide(color: Theme.of(context).primaryColor),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(16),
          //             ),
          //           ),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(
          //                 previousButtonIcon,
          //                 size: 18,
          //                 color: Colors.white,
          //               ),
          //               const SizedBox(width: 6),
          //               Text(
          //                 previousButtonText,
          //                 style: const TextStyle(
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.bold,
          //                   color: Colors.white,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: SizedBox(
          //         height: 50,
          //         child: ElevatedButton(
          //           onPressed: onNext,
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: Theme.of(context).primaryColor,
          //             foregroundColor: Colors.white,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(16),
          //             ),
          //           ),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(
          //                 nextButtonText,
          //                 style: const TextStyle(
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               const SizedBox(width: 6),
          //               Icon(nextButtonIcon, size: 18),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // );
        },
      ),
    );
  }
}
