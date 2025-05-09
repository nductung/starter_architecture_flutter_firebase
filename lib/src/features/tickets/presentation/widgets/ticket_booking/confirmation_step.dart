import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/trip_model.dart';
import 'summary_row.dart';
import 'navigation_buttons.dart';

class ConfirmationStep extends StatelessWidget {
  const ConfirmationStep({
    super.key,
    required this.trip,
    required this.date,
    required this.fullNameController,
    required this.phoneController,
    required this.pickupPointController,
    required this.destinationPointController,
    required this.isSubmitting,
    required this.onPrevious,
    required this.onSubmit,
    required this.showErrorMessage,
    required this.setCurrentStep,
  });

  final Trip trip;
  final DateTime date;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController pickupPointController;
  final TextEditingController destinationPointController;
  final bool isSubmitting;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;
  final Function(String) showErrorMessage;
  final Function(int) setCurrentStep;

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu dữ liệu đầu vào trống, hiển thị thông báo lỗi
    final String fullName = fullNameController.text.trim();
    final String phoneNumber = phoneController.text.trim();
    final String pickupPoint = pickupPointController.text.trim();
    final String destinationPoint = destinationPointController.text.trim();

    bool hasEmptyFields = fullName.isEmpty ||
        phoneNumber.isEmpty ||
        pickupPoint.isEmpty ||
        destinationPoint.isEmpty;

    bool hasInvalidPhone = !RegExp(r'^\d{10,11}$').hasMatch(phoneNumber);

    if (hasEmptyFields || hasInvalidPhone) {
      // Lùi lại bước nhập thông tin nếu có trường không hợp lệ
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setCurrentStep(1);
        showErrorMessage('Vui lòng kiểm tra lại thông tin hành khách');
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xác nhận đặt vé',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Vui lòng kiểm tra lại thông tin trước khi xác nhận',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),

        // Trip summary card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.indigo.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.directions_bus_rounded,
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Thông tin chuyến xe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              SummaryRow(label: 'Mã chuyến:', value: trip.code),
              SummaryRow(
                  label: 'Tuyến đường:',
                  value: '${trip.origin} → ${trip.destination}'),
              SummaryRow(
                  label: 'Ngày đi:', 
                  value: DateFormat('dd/MM/yyyy').format(date)),
              SummaryRow(label: 'Giờ khởi hành:', value: trip.departureTime),
              SummaryRow(
                  label: 'Giá vé:',
                  value: NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                      .format(trip.price)),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Passenger info card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.blue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person_rounded,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Thông tin hành khách',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              SummaryRow(label: 'Họ tên:', value: fullNameController.text),
              SummaryRow(label: 'Số điện thoại:', value: phoneController.text),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Pickup/Dropoff info card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.green.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Thông tin điểm đón/trả',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              SummaryRow(
                  label: 'Điểm đón:', value: pickupPointController.text),
              SummaryRow(
                  label: 'Điểm đến:', value: destinationPointController.text),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Payment disclaimer
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.amber.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Colors.amber,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Thanh toán trực tiếp khi lên xe. Vui lòng có mặt trước giờ khởi hành 15 phút.',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Navigation buttons
        Padding(
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
                        onPressed: isSubmitting ? null : onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.check_circle_outline_rounded, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'Xác nhận đặt vé',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                          children: const [
                            Icon(Icons.arrow_back_rounded, size: 18, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'Quay lại',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
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
              //             children: const [
              //               Icon(Icons.arrow_back_rounded, size: 18),
              //               SizedBox(width: 6),
              //               Text(
              //                 'Quay lại',
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.bold,
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
              //           onPressed: isSubmitting ? null : onSubmit,
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.green,
              //             foregroundColor: Colors.white,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(16),
              //             ),
              //           ),
              //           child: isSubmitting
              //               ? const SizedBox(
              //                   width: 24,
              //                   height: 24,
              //                   child: CircularProgressIndicator(
              //                     strokeWidth: 2,
              //                     color: Colors.white,
              //                   ),
              //                 )
              //               : Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: const [
              //                     Icon(Icons.check_circle_outline_rounded, size: 18),
              //                     SizedBox(width: 6),
              //                     Text(
              //                       'Xác nhận đặt vé',
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //         ),
              //       ),
              //     ),
              //   ],
              // );
            },
          ),
        ),
      ],
    );
  }
} 