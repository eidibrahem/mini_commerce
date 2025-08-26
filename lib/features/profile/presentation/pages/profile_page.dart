import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // TODO: Get actual user ID from auth provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile('user123');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit profile functionality coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppConstants.errorColor,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    profileProvider.errorMessage!,
                    style: TextStyle(color: AppConstants.errorColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  ElevatedButton(
                    onPressed: () {
                      profileProvider.loadProfile('user123');
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!profileProvider.hasProfile) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  Text(
                    'No profile found',
                    style: AppConstants.headingStyle.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    'Create your profile to get started',
                    style: AppConstants.bodyStyle.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to create profile page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Create profile functionality coming soon!',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Create Profile'),
                  ),
                ],
              ),
            );
          }

          final profile = profileProvider.profile!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            profile.profileImageUrl != null
                                ? NetworkImage(profile.profileImageUrl!)
                                : null,
                        child:
                            profile.profileImageUrl == null
                                ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey[400],
                                )
                                : null,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      Text(
                        profile.fullName,
                        style: AppConstants.headingStyle.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      if (profile.phoneNumber != null) ...[
                        const SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          profile.phoneNumber!,
                          style: AppConstants.bodyStyle.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.paddingXLarge),

                // Personal Information Section
                _buildSectionHeader('Personal Information'),
                const SizedBox(height: AppConstants.paddingMedium),

                _buildInfoRow('First Name', profile.firstName),
                _buildInfoRow('Last Name', profile.lastName),
                if (profile.dateOfBirth != null)
                  _buildInfoRow(
                    'Date of Birth',
                    '${profile.dateOfBirth!.day}/${profile.dateOfBirth!.month}/${profile.dateOfBirth!.year}',
                  ),

                const SizedBox(height: AppConstants.paddingLarge),

                // Address Section
                if (profile.address != null ||
                    profile.city != null ||
                    profile.state != null) ...[
                  _buildSectionHeader('Address'),
                  const SizedBox(height: AppConstants.paddingMedium),

                  if (profile.address != null)
                    _buildInfoRow('Address', profile.address!),
                  if (profile.city != null)
                    _buildInfoRow('City', profile.city!),
                  if (profile.state != null)
                    _buildInfoRow('State', profile.state!),
                  if (profile.zipCode != null)
                    _buildInfoRow('ZIP Code', profile.zipCode!),
                  if (profile.country != null)
                    _buildInfoRow('Country', profile.country!),

                  const SizedBox(height: AppConstants.paddingLarge),
                ],

                // Account Information Section
                _buildSectionHeader('Account Information'),
                const SizedBox(height: AppConstants.paddingMedium),

                _buildInfoRow('User ID', profile.userId),
                _buildInfoRow(
                  'Member Since',
                  '${profile.createdAt.day}/${profile.createdAt.month}/${profile.createdAt.year}',
                ),
                _buildInfoRow(
                  'Last Updated',
                  '${profile.updatedAt.day}/${profile.updatedAt.month}/${profile.updatedAt.year}',
                ),

                const SizedBox(height: AppConstants.paddingXLarge),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to edit profile page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Edit profile functionality coming soon!',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.paddingMedium),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to settings page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings functionality coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('Settings'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppConstants.headingStyle.copyWith(
        fontSize: 20,
        color: AppConstants.primaryColor,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppConstants.bodyStyle.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(child: Text(value, style: AppConstants.bodyStyle)),
        ],
      ),
    );
  }
}
