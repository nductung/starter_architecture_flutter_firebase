import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/string_hardcoded.dart';

class BusCompanyInfoScreen extends StatelessWidget {
  const BusCompanyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'bus_company_info'.tr(context),
                        style: theme.textTheme.headlineMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Company info container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
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
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          
                          // Company logo
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.directions_bus_rounded,
                              size: 60,
                              color: theme.primaryColor,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Company name
                          Text(
                            'Phương Trang Bus'.hardcoded,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Company tagline
                          Text(
                            'safe_journey'.tr(context),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Contact info
                          _buildInfoSection(
                            context,
                            title: 'contact_info'.tr(context),
                            items: [
                              _InfoItem(
                                icon: Icons.phone,
                                title: 'hotline'.tr(context),
                                value: '1900 6067',
                              ),
                              _InfoItem(
                                icon: Icons.email,
                                title: 'email'.tr(context),
                                value: 'support@phuongtrang.vn',
                              ),
                              _InfoItem(
                                icon: Icons.language,
                                title: 'website'.tr(context),
                                value: 'www.phuongtrang.vn',
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // About section
                          _buildInfoSection(
                            context,
                            title: 'about_us'.tr(context),
                            items: [
                              _InfoItem(
                                icon: Icons.history,
                                title: 'founded'.tr(context),
                                value: '2001',
                              ),
                              _InfoItem(
                                icon: Icons.location_city,
                                title: 'headquarters'.tr(context),
                                value: 'TP. Hồ Chí Minh',
                              ),
                              _InfoItem(
                                icon: Icons.directions_bus_filled,
                                title: 'fleet_size'.tr(context),
                                value: '1000+',
                              ),
                              _InfoItem(
                                icon: Icons.map,
                                title: 'service_area'.tr(context),
                                value: '63 ' + 'provinces'.tr(context),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Service section
                          _buildInfoSection(
                            context,
                            title: 'services'.tr(context),
                            items: [
                              _InfoItem(
                                icon: Icons.airline_seat_recline_extra,
                                title: 'seat_types'.tr(context),
                                value: 'standard_vip_limousine'.tr(context),
                              ),
                              _InfoItem(
                                icon: Icons.wifi,
                                title: 'amenities'.tr(context),
                                value: 'wifi_drinks_towels'.tr(context),
                              ),
                              _InfoItem(
                                icon: Icons.payments_outlined,
                                title: 'payment_methods'.tr(context),
                                value: 'cash_card_transfer'.tr(context),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Support channels
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'support_channels'.tr(context),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildSupportButton(
                                      context,
                                      icon: Icons.chat,
                                      label: 'chat'.tr(context),
                                    ),
                                    _buildSupportButton(
                                      context,
                                      icon: Icons.phone,
                                      label: 'call'.tr(context),
                                    ),
                                    _buildSupportButton(
                                      context,
                                      icon: Icons.mail,
                                      label: 'email'.tr(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required List<_InfoItem> items,
  }) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: theme.dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: items.map((item) {
                  final isLast = items.last == item;
                  return Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item.icon,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          item.value,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      if (!isLast) Divider(height: 1, indent: 70, endIndent: 24),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSupportButton(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () {
        // Show "feature updating" dialog when clicked
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.update,
                  color: theme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text('feature_updating'.tr(context)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.construction,
                    color: theme.primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'feature_updating'.tr(context),
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'feature_updating_message'.tr(context),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('close'.tr(context)),
              ),
            ],
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: theme.primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String title;
  final String value;
  
  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });
} 