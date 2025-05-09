import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/bus_company_info_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/settings/presentation/language_selection_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/string_hardcoded.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'profile'.tr(context),
                    style: theme.textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Profile container
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
                    child: StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        final user = snapshot.data;
                        final isVerified = user?.emailVerified ?? false;
                        
                        return Column(
                          children: [
                            const SizedBox(height: 32),
                            
                            // Avatar
                            _buildUserAvatar(context, user),
                            
                            const SizedBox(height: 16),
                            
                            // User name if available and verified
                            if (isVerified && user?.displayName != null && user!.displayName!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                child: Text(
                                  user.displayName!,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              
                            // Email with verification status
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      user?.email ?? 'Anonymous'.hardcoded,
                                      style: theme.textTheme.titleMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  if (user?.email != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        isVerified ? Icons.verified_user : Icons.info_outline,
                                        size: 16,
                                        color: isVerified ? Colors.green : Colors.orange,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            
                            // Verification status text
                            if (user?.email != null && !isVerified)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'email_not_verified'.tr(context),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.orange,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            
                            const SizedBox(height: 32),
                            
                            // Options List
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: theme.dividerColor.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildOptionItem(
                                      context,
                                      icon: Icons.language_outlined,
                                      title: 'language'.tr(context),
                                      subtitle: Localizations.localeOf(context).languageCode == 'vi' 
                                          ? 'Tiếng Việt'.hardcoded 
                                          : 'English'.hardcoded,
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const LanguageSelectionScreen(),
                                        ),
                                      ),
                                    ),
                                    Divider(height: 1, indent: 70, endIndent: 24),
                                    _buildOptionItem(
                                      context,
                                      icon: Icons.dark_mode_outlined,
                                      title: 'theme'.tr(context),
                                      subtitle: 'light'.tr(context),
                                      onTap: () => _showFeatureUpdateDialog(context),
                                    ),
                                    Divider(height: 1, indent: 70, endIndent: 24),
                                    _buildOptionItem(
                                      context,
                                      icon: Icons.help_outline,
                                      title: 'support'.tr(context),
                                      subtitle: 'bus_company_info'.tr(context),
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const BusCompanyInfoScreen(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Sign out button
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: theme.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                  },
                                  icon: const Icon(Icons.logout),
                                  label: Text('sign_out'.tr(context)),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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

  Widget _buildUserAvatar(BuildContext context, User? user) {
    final theme = Theme.of(context);
    final isVerified = user?.emailVerified ?? false;
    
    // Check if user has a photo URL
    if (isVerified && user?.photoURL != null) {
      return Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.primaryColor,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                user!.photoURL!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / 
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: theme.primaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.verified_user,
                size: 20,
                color: Colors.green,
              ),
            ),
          ),
        ],
      );
    }
    
    // Default avatar
    return CircleAvatar(
      radius: 50,
      backgroundColor: theme.primaryColor.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: 60,
        color: theme.primaryColor,
      ),
    );
  }
  
  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: theme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFeatureUpdateDialog(BuildContext context) {
    final theme = Theme.of(context);
    
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
  }
}
