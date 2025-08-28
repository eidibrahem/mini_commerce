import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../core/constants.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../../../app/router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _countryController;

  // User data
  Map<String, dynamic>? _userData;
  String? _userId;
  bool _isLoading = false;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _countryController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user ID from cache
      _userId = await CacheHelper.getData(key: 'uId');

      if (_userId != null) {
        // Get current Firebase Auth user for additional data
        final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

        // Load user data from Firestore
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_userId)
                .get();

        if (userDoc.exists) {
          _userData = userDoc.data();
          print('📱 ProfilePage: Loaded user data from Firestore: $_userData');
        } else {
          // Create default user data if document doesn't exist
          _userData = {
            'name': '',
            'email': '',
            'phone': '',
            'address': '',
            'city': '',
            'state': '',
            'zipCode': '',
            'country': '',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          };
          print('📱 ProfilePage: Created default user data');
        }

        // Merge with Firebase Auth data if available
        if (currentUser != null) {
          _userData!['email'] = currentUser.email ?? _userData!['email'] ?? '';

          // If Firestore doesn't have name data, try to get from Auth user
          if ((_userData!['name']?.isEmpty ?? true) &&
              currentUser.displayName != null) {
            _userData!['name'] = currentUser.displayName!;
          }

          print('📱 ProfilePage: Merged with Firebase Auth data:');
          print('  Auth Email: ${currentUser.email}');
          print('  Auth Display Name: ${currentUser.displayName}');
        }

        _populateFormFields();
      }
    } catch (e) {
      print('❌ ProfilePage: Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateFormFields() {
    if (_userData != null) {
      // Split the name into first and last name for display
      final fullName = _userData!['name'] ?? '';
      final nameParts = fullName.split(' ');
      _firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
      _lastNameController.text =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      _emailController.text = _userData!['email'] ?? '';
      _phoneController.text = _userData!['phone'] ?? '';
      _addressController.text = _userData!['address'] ?? '';
      _cityController.text = _userData!['city'] ?? '';
      _stateController.text = _userData!['state'] ?? '';
      _zipCodeController.text = _userData!['zipCode'] ?? '';
      _countryController.text = _userData!['country'] ?? '';

      print('📱 ProfilePage: Populated form fields:');
      print('  Full Name: "$fullName"');
      print('  First Name: "${_firstNameController.text}"');
      print('  Last Name: "${_lastNameController.text}"');
      print('  Email: "${_emailController.text}"');
      print('  Phone: "${_phoneController.text}"');
      print('  Address: "${_addressController.text}"');
      print('  City: "${_cityController.text}"');
      print('  State: "${_stateController.text}"');
      print('  ZIP: "${_zipCodeController.text}"');
      print('  Country: "${_countryController.text}"');
    }
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // Cancel editing - restore original values
        _populateFormFields();
      }
      _isEditing = !_isEditing;
    });
  }

  Future<void> _pickAndUpdateImage() async {
    try {
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (pickedImage != null) {
        setState(() {
          _isLoading = true;
        });

        // For now, we'll just update the local data
        // In a real app, you'd upload to Firebase Storage
        _userData!['photoUrl'] = pickedImage.path;

        // Update the UI
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile image updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Update user data
        final updatedData = {
          'name':
              '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                  .trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'city': _cityController.text.trim(),
          'state': _stateController.text.trim(),
          'zipCode': _zipCodeController.text.trim(),
          'country': _countryController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .set(updatedData, SetOptions(merge: true));

        // Update local data
        _userData = {..._userData!, ...updatedData};

        // Exit edit mode
        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('❌ Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    // Show confirmation dialog if user is editing
    if (_isEditing) {
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Discard Changes?'),
            content: const Text(
              'You have unsaved changes. Are you sure you want to logout and discard these changes?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Logout'),
              ),
            ],
          );
        },
      );

      if (shouldLogout != true) {
        return; // User cancelled logout
      }
    }

    try {
      setState(() {
        _isLoading = true;
      });

      // Get the auth provider
      final authProvider = context.read<AuthProvider>();

      // Sign out from Firebase Auth
      await authProvider.signOutUser();

      // Clear ALL cached user data comprehensively
      await CacheHelper.removeData(key: 'uId');
      await CacheHelper.removeData(key: 'userData');
      await CacheHelper.removeData(key: 'userProfile');
      await CacheHelper.removeData(key: 'userEmail');
      await CacheHelper.removeData(key: 'userName');

      // Clear all cached data completely (nuclear option)
      await CacheHelper.clearData();

      // Clear all local files and caches comprehensively
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final cacheDir = await getTemporaryDirectory();

        // Clear app documents directory (user-specific files)
        if (await appDir.exists()) {
          final files = appDir.listSync();
          for (final file in files) {
            if (file is File &&
                (file.path.contains('profile') || file.path.contains('user'))) {
              await file.delete();
            }
          }
        }

        // Clear entire cache directory (nuclear option)
        if (await cacheDir.exists()) {
          await cacheDir.delete(recursive: true);
        }

        // Clear any temporary profile images
        if (_userData?['photoUrl'] != null &&
            !_userData!['photoUrl']!.startsWith('http')) {
          final imageFile = File(_userData!['photoUrl']!);
          if (await imageFile.exists()) {
            await imageFile.delete();
          }
        }
      } catch (e) {
        print('⚠️ Warning: Could not clear some local files: $e');
        // Continue with logout even if file clearing fails
      }

      // Clear local user data
      setState(() {
        _userData = null;
        _userId = null;
      });

      // Force clear Firebase Auth state
      await firebase_auth.FirebaseAuth.instance.signOut();

      // Clear any potential Firebase Firestore cache
      try {
        await FirebaseFirestore.instance.clearPersistence();
      } catch (e) {
        print('⚠️ Warning: Could not clear Firestore persistence: $e');
        // Continue with logout even if Firestore clearing fails
      }

      // Clear all providers that might hold user data
      if (mounted) {
        // Clear cart data
        context.read<CartProvider>().clearCartData();

        // Clear profile data
        context.read<ProfileProvider>().clearProfileData();

        // Clear auth provider data locally
        context.read<AuthProvider>().clearAuthData();
      }

      // Navigate to login page and remove all previous routes
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.login,
          (route) => false, // Remove all previous routes
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'Profile'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEditMode,
              tooltip: 'Edit Profile',
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleEditMode,
              tooltip: 'Cancel',
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
              tooltip: 'Save Changes',
            ),
          ],
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppConstants.primaryColor,
                  ),
                ),
              )
              : _userData == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'Failed to load profile',
                      style: AppConstants.headingStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    ElevatedButton(
                      onPressed: _loadUserData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _isEditing ? _pickAndUpdateImage : null,
                              child: Tooltip(
                                message:
                                    _isEditing
                                        ? 'Tap to change profile picture'
                                        : '',
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          (_userData!['photoUrl']?.isNotEmpty ==
                                                  true)
                                              ? (_userData!['photoUrl']!
                                                      .startsWith('http')
                                                  ? NetworkImage(
                                                    _userData!['photoUrl']!,
                                                  )
                                                  : FileImage(
                                                        File(
                                                          _userData!['photoUrl']!,
                                                        ),
                                                      )
                                                      as ImageProvider)
                                              : null,
                                      backgroundColor: AppConstants.primaryColor
                                          .withOpacity(0.1),
                                      child:
                                          (_userData!['photoUrl']?.isNotEmpty ==
                                                  true)
                                              ? null
                                              : Icon(
                                                Icons.person,
                                                size: 60,
                                                color:
                                                    AppConstants.primaryColor,
                                              ),
                                    ),
                                    if (_isEditing)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppConstants.primaryColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    if (_isLoading)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppConstants.paddingMedium),
                            if (!_isEditing) ...[
                              Text(
                                (_userData!['name'] ?? '').trim().isEmpty
                                    ? 'Your Profile'
                                    : _userData!['name'],
                                style: AppConstants.headingStyle.copyWith(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_userData!['email']?.isNotEmpty == true) ...[
                                const SizedBox(
                                  height: AppConstants.paddingSmall,
                                ),
                                Text(
                                  _userData!['email'],
                                  style: AppConstants.bodyStyle.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ] else ...[
                              Text(
                                'Edit Your Profile',
                                style: AppConstants.headingStyle.copyWith(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppConstants.paddingSmall),
                              Text(
                                'Make changes to your information below',
                                style: AppConstants.bodyStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.paddingXLarge),

                      // Personal Information Section
                      _buildSectionHeader('Personal Information'),
                      const SizedBox(height: AppConstants.paddingMedium),

                      if (_isEditing) ...[
                        _buildFormField(
                          'First Name',
                          _firstNameController,
                          Icons.person,
                          true,
                        ),
                        _buildFormField(
                          'Last Name',
                          _lastNameController,
                          Icons.person,
                          true,
                        ),
                        _buildFormField(
                          'Email',
                          _emailController,
                          Icons.email,
                          true,
                        ),
                        _buildFormField(
                          'Phone Number',
                          _phoneController,
                          Icons.phone,
                          false,
                        ),
                      ] else ...[
                        _buildInfoRow(
                          'First Name',
                          _userData!['name']?.split(' ').first ?? '',
                        ),
                        _buildInfoRow(
                          'Last Name',
                          _userData!['name']?.split(' ').skip(1).join(' ') ??
                              '',
                        ),
                        if (_userData!['email']?.isNotEmpty == true)
                          _buildInfoRow('Email', _userData!['email']),
                        if (_userData!['phone']?.isNotEmpty == true)
                          _buildInfoRow('Phone Number', _userData!['phone']),
                      ],

                      const SizedBox(height: AppConstants.paddingLarge),

                      // Address Section
                      _buildSectionHeader('Address'),
                      const SizedBox(height: AppConstants.paddingMedium),

                      if (_isEditing) ...[
                        _buildFormField(
                          'Address',
                          _addressController,
                          Icons.home,
                          false,
                        ),
                        _buildFormField(
                          'City',
                          _cityController,
                          Icons.location_city,
                          false,
                        ),
                        _buildFormField(
                          'State',
                          _stateController,
                          Icons.map,
                          false,
                        ),
                        _buildFormField(
                          'ZIP Code',
                          _zipCodeController,
                          Icons.pin_drop,
                          false,
                        ),
                        _buildFormField(
                          'Country',
                          _countryController,
                          Icons.public,
                          false,
                        ),
                      ] else ...[
                        if (_userData!['address']?.isNotEmpty == true)
                          _buildInfoRow('Address', _userData!['address']),
                        if (_userData!['city']?.isNotEmpty == true)
                          _buildInfoRow('City', _userData!['city']),
                        if (_userData!['state']?.isNotEmpty == true)
                          _buildInfoRow('State', _userData!['state']),
                        if (_userData!['zipCode']?.isNotEmpty == true)
                          _buildInfoRow('ZIP Code', _userData!['zipCode']),
                        if (_userData!['country']?.isNotEmpty == true)
                          _buildInfoRow('Country', _userData!['country']),
                      ],

                      const SizedBox(height: AppConstants.paddingLarge),

                      // Account Information Section
                      _buildSectionHeader('Account Information'),
                      const SizedBox(height: AppConstants.paddingMedium),

                      _buildInfoRow('User ID', _userId ?? ''),
                      if (_userData!['createdAt'] != null)
                        _buildInfoRow('Member Since', 'Profile created'),
                      if (_userData!['updatedAt'] != null)
                        _buildInfoRow('Last Updated', 'Recently updated'),

                      const SizedBox(height: AppConstants.paddingXLarge),

                      // Action Buttons
                      if (!_isEditing) ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _toggleEditMode,
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Profile'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryColor,
                              foregroundColor: Colors.white,
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
                                  content: Text(
                                    'Settings functionality coming soon!',
                                  ),
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

                        const SizedBox(height: AppConstants.paddingMedium),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.paddingMedium,
                              ),
                              side: BorderSide(
                                color: Colors.red[400] ?? Colors.red,
                              ),
                              foregroundColor: Colors.red[400] ?? Colors.red,
                            ),
                          ),
                        ),
                      ] else ...[
                        // Save and Cancel buttons when editing
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _toggleEditMode,
                                icon: const Icon(Icons.close),
                                label: const Text('Cancel'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppConstants.paddingMedium,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppConstants.paddingMedium),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _saveProfile,
                                icon: const Icon(Icons.save),
                                label: const Text('Save Changes'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConstants.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppConstants.paddingMedium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppConstants.paddingLarge),

                        // Logout button when editing
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.paddingMedium,
                              ),
                              side: BorderSide(
                                color: Colors.red[400] ?? Colors.red,
                              ),
                              foregroundColor: Colors.red[400] ?? Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppConstants.headingStyle.copyWith(
        fontSize: 20,
        color: Colors.white,
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
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Text(
              value,
              style: AppConstants.bodyStyle.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isRequired,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppConstants.bodyStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red[400] ?? Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: _getKeyboardType(label),
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Enter ${label.toLowerCase()}',
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusSmall,
                ),
                borderSide: BorderSide(color: Colors.grey[300] ?? Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusSmall,
                ),
                borderSide: BorderSide(color: Colors.grey[300] ?? Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusSmall,
                ),
                borderSide: BorderSide(
                  color: AppConstants.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusSmall,
                ),
                borderSide: BorderSide(color: Colors.red[400] ?? Colors.red),
              ),
              filled: true,
              fillColor: Colors.grey[50] ?? Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingMedium,
              ),
            ),
            validator: (value) {
              if (isRequired && (value == null || value.trim().isEmpty)) {
                return '$label is required';
              }
              // Email validation
              if (label == 'Email' &&
                  value != null &&
                  value.trim().isNotEmpty) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  TextInputType _getKeyboardType(String label) {
    switch (label.toLowerCase()) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone number':
        return TextInputType.phone;
      case 'zip code':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}
