import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'dart:ui';
import 'dart:io';
import '../../../common_widgets/async_value_widget.dart';
import '../../../constants/app_sizes.dart';
import '../application/ticket_service.dart';
import '../domain/trip_model.dart';
import 'my_tickets_screen.dart';
import 'widgets/ticket_booking/booking_app_bar.dart';
import 'widgets/ticket_booking/booking_step_indicator.dart';
import 'widgets/ticket_booking/trip_info_step.dart';
import 'widgets/ticket_booking/passenger_info_step.dart';
import 'widgets/ticket_booking/confirmation_step.dart';

class TicketBookingScreen extends ConsumerStatefulWidget {
  const TicketBookingScreen({
    super.key,
    required this.trip,
    required this.date,
  });

  final Trip trip;
  final DateTime date;

  static const path = '/book-ticket';

  @override
  ConsumerState<TicketBookingScreen> createState() =>
      _TicketBookingScreenState();
}

class _TicketBookingScreenState extends ConsumerState<TicketBookingScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pickupPointController = TextEditingController();
  final _destinationPointController = TextEditingController();

  bool _isSubmitting = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    // Pre-fill pickup and destination with trip origin and destination
    _pickupPointController.text = "";
    _destinationPointController.text = "";

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();

    // Ensure form is initialized after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          // This forces a rebuild to ensure form is properly initialized
        });
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _pickupPointController.dispose();
    _destinationPointController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập họ tên';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  String? validatePickupPoint(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập điểm đón';
    }
    return null;
  }

  String? validateDestinationPoint(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập điểm đến';
    }
    return null;
  }

  void nextStep() {
    // Validate current step before proceeding
    if (_currentStep == 0) {
      setState(() {
        _currentStep++;
      });
      _animationController.reset();
      _animationController.forward();
    } else if (_currentStep == 1) {
      // Check for null formKey.currentState before validation
      if (_formKey.currentState == null) {
        showErrorMessage('Có lỗi xảy ra với form, vui lòng thử lại');
        return;
      }

      if (_formKey.currentState!.validate()) {
        setState(() {
          _currentStep++;
        });
        _animationController.reset();
        _animationController.forward();
      }
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  Future<void> submitForm() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      // Kiểm tra kết nối mạng trước khi thực hiện API call
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isEmpty || result[0].rawAddress.isEmpty) {
          throw Exception('Không có kết nối mạng');
        }
      } on SocketException catch (_) {
        throw Exception('Không có kết nối mạng');
      }

      // Kiểm tra xem trip có bị null hay không
      if (widget.trip.id.isEmpty) {
        throw Exception('Không tìm thấy thông tin chuyến đi');
      }

      // Get user ID from authentication (mocked here)
      final user = ref.watch(authRepositoryProvider).currentUser;

      if (user == null) return;

      final ticketService = ref.read(ticketServiceProvider);

      // Bảo vệ khỏi null cho tất cả các tham số
      final String fullName = _fullNameController.text.trim();
      final String phoneNumber = _phoneController.text.trim();
      final String pickupPoint = _pickupPointController.text.trim();
      final String destinationPoint = _destinationPointController.text.trim();

      // Kiểm tra dữ liệu đầu vào
      if (fullName.isEmpty) {
        throw Exception('Họ tên không được để trống');
      }

      if (phoneNumber.isEmpty) {
        throw Exception('Số điện thoại không được để trống');
      }

      if (!RegExp(r'^\d{10,11}$').hasMatch(phoneNumber)) {
        throw Exception('Số điện thoại không hợp lệ');
      }

      if (pickupPoint.isEmpty) {
        throw Exception('Điểm đón không được để trống');
      }

      if (destinationPoint.isEmpty) {
        throw Exception('Điểm đến không được để trống');
      }

      await ticketService.bookTicket(
        userId: user.uid,
        fullName: fullName,
        phoneNumber: phoneNumber,
        pickupPoint: pickupPoint,
        destinationPoint: destinationPoint,
        tripId: widget.trip.id,
        tripDate: widget.date,
      );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt vé thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to My Tickets screen
        context.go(MyTicketsScreen.path);
      }
    } catch (e) {
      // Show error message
      showErrorMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // Hàm hiển thị thông báo lỗi để tránh lặp code
  void showErrorMessage(String errorMessage) {
    if (!mounted) return;

    String displayMessage = errorMessage;
    // Rút gọn thông báo lỗi nếu quá dài
    if (errorMessage.contains('Exception:')) {
      displayMessage = errorMessage.split('Exception:')[1].trim();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lỗi: $displayMessage'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                  Theme.of(context).primaryColor.withOpacity(0.6),
                  Colors.white,
                ],
                stops: const [0.0, 0.3, 0.5, 0.9],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar
                BookingAppBar(
                  currentStep: _currentStep,
                  onBackPressed: () => Navigator.of(context).pop(),
                ),

                // Step indicator
                BookingStepIndicator(currentStep: _currentStep),

                // Main content area
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildCurrentStep(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return TripInfoStep(
          trip: widget.trip,
          date: widget.date,
          onContinue: nextStep,
        );
      case 1:
        return PassengerInfoStep(
          formKey: _formKey,
          fullNameController: _fullNameController,
          phoneController: _phoneController,
          pickupPointController: _pickupPointController,
          destinationPointController: _destinationPointController,
          validateName: validateName,
          validatePhone: validatePhone,
          validatePickupPoint: validatePickupPoint,
          validateDestinationPoint: validateDestinationPoint,
          onPrevious: previousStep,
          onNext: nextStep,
        );
      case 2:
        return ConfirmationStep(
          trip: widget.trip,
          date: widget.date,
          fullNameController: _fullNameController,
          phoneController: _phoneController,
          pickupPointController: _pickupPointController,
          destinationPointController: _destinationPointController,
          isSubmitting: _isSubmitting,
          onPrevious: previousStep,
          onSubmit: submitForm,
          showErrorMessage: showErrorMessage,
          setCurrentStep: (step) => setState(() => _currentStep = step),
        );
      default:
        return TripInfoStep(
          trip: widget.trip,
          date: widget.date,
          onContinue: nextStep,
        );
    }
  }
}
