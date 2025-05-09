import 'package:flutter/material.dart';
import 'booking_input_field.dart';
import 'navigation_buttons.dart';

class PassengerInfoStep extends StatelessWidget {
  const PassengerInfoStep({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.phoneController,
    required this.pickupPointController,
    required this.destinationPointController,
    required this.validateName,
    required this.validatePhone,
    required this.validatePickupPoint,
    required this.validateDestinationPoint,
    required this.onPrevious,
    required this.onNext,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController pickupPointController;
  final TextEditingController destinationPointController;
  final String? Function(String?) validateName;
  final String? Function(String?) validatePhone;
  final String? Function(String?) validatePickupPoint;
  final String? Function(String?) validateDestinationPoint;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin hành khách',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          // Full name field
          BookingInputField(
            controller: fullNameController,
            label: 'Họ tên',
            hintText: 'Nhập họ tên của bạn',
            icon: Icons.person_rounded,
            iconColor: Colors.blue,
            validator: validateName,
          ),

          const SizedBox(height: 16),

          // Phone field
          BookingInputField(
            controller: phoneController,
            label: 'Số điện thoại',
            hintText: 'Nhập số điện thoại liên hệ',
            icon: Icons.phone_rounded,
            iconColor: Colors.green,
            validator: validatePhone,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 24),

          Text(
            'Thông tin điểm đón/trả',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Pickup point field
          BookingInputField(
            controller: pickupPointController,
            label: 'Điểm đón',
            hintText: 'Nhập địa điểm chi tiết',
            icon: Icons.trip_origin_rounded,
            iconColor: Colors.green,
            validator: validatePickupPoint,
          ),

          const SizedBox(height: 16),

          // Destination point field
          BookingInputField(
            controller: destinationPointController,
            label: 'Điểm đến',
            hintText: 'Nhập địa điểm chi tiết',
            icon: Icons.location_on_rounded,
            iconColor: Colors.red,
            validator: validateDestinationPoint,
          ),

          const SizedBox(height: 32),

          // Navigation buttons
          NavigationButtons(
            onPrevious: onPrevious,
            onNext: onNext,
          ),
        ],
      ),
    );
  }
} 