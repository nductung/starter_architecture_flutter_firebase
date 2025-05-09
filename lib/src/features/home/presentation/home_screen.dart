import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/features/tickets/data/init_sample_data.dart';
import 'package:starter_architecture_flutter_firebase/src/features/tickets/presentation/trip_list_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/string_hardcoded.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                  Colors.white,
                ],
                stops: const [0.0, 0.3, 0.6],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: Icon(
                          Icons.directions_bus_rounded,
                          color: Colors.indigo,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'home'.tr(context),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'company_slogan'.tr(context),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Main content
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'welcome_message'.tr(context),
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'travel_description'.tr(context),
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Colors.black54,
                                ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Route cards
                          Row(
                            children: [
                              _buildRouteCard(
                                context,
                                'thanh_hoa_to_hanoi'.tr(context),
                                'departure_times'.tr(context).replaceAll('{times}', '06:00, 12:00'),
                                Colors.blue.shade700,
                                Icons.trending_up_rounded,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const TripListScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              _buildRouteCard(
                                context,
                                'hanoi_to_thanh_hoa'.tr(context),
                                'departure_times'.tr(context).replaceAll('{times}', '10:00, 16:00'),
                                Colors.orange.shade700,
                                Icons.trending_down_rounded,
                                onTap: () {
                                  // Pre-fill destination and origin
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const TripListScreen(
                                        initialOrigin: 'Hà Nội',
                                        initialDestination: 'Thanh Hoá',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Quick actions
                          Text(
                            'quick_actions'.tr(context),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                          const SizedBox(height: 16),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildQuickAction(
                                context,
                                'book_ticket'.tr(context),
                                Icons.confirmation_number_outlined,
                                Colors.green.shade100,
                                Colors.green,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const TripListScreen(),
                                    ),
                                  );
                                },
                              ),
                              _buildQuickAction(
                                context,
                                'my_tickets'.tr(context),
                                Icons.receipt_long_outlined,
                                Colors.purple.shade100,
                                Colors.purple,
                                onTap: () {
                                  context.goNamed(AppRoute.myTickets.name);
                                },
                              ),
                              _buildQuickAction(
                                context,
                                'support'.tr(context),
                                Icons.support_agent_outlined,
                                Colors.orange.shade100,
                                Colors.orange,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('feature_updating_message'.tr(context)),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
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
  
  Widget _buildRouteCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black54,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    Color bgColor,
    Color iconColor, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
