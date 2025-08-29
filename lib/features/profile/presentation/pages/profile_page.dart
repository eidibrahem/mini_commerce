import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_cropper/image_cropper.dart';
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
import '../../../products/presentation/providers/send_notification_services.dart';

enum ImageSelectionOption { camera, gallery, galleryNoCrop }

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
  double _uploadProgress = 0.0;

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

        // Send notification about profile loaded
        await _sendNotification(
          title: 'Profile Loaded',
          body: 'Your profile has been loaded successfully',
          data: {
            'type': 'profile_loaded',
            'action': 'load_success',
            'userId': _userId ?? '',
          },
        );
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

  void _toggleEditMode() async {
    setState(() {
      if (_isEditing) {
        // Cancel editing - restore original values
        _populateFormFields();
      }
      _isEditing = !_isEditing;
    });

    // Send notification about edit mode change
    if (_isEditing) {
      await _sendNotification(
        title: 'Edit Mode Enabled',
        body: 'You can now edit your profile information',
        data: {
          'type': 'profile_edit',
          'action': 'edit_mode_enabled',
          'userId': _userId ?? '',
        },
      );
    }
  }

  /// Shows a dialog to select image source (camera or gallery)
  Future<ImageSelectionOption?> _showImageSourceDialog() async {
    return await showDialog<ImageSelectionOption>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: const Text('Choose where to get your profile picture from'),
          actions: [
            TextButton.icon(
              onPressed:
                  () => Navigator.of(context).pop(ImageSelectionOption.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
            ),
            TextButton.icon(
              onPressed:
                  () => Navigator.of(context).pop(ImageSelectionOption.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
            ),
            TextButton.icon(
              onPressed:
                  () => Navigator.of(
                    context,
                  ).pop(ImageSelectionOption.galleryNoCrop),
              icon: const Icon(Icons.skip_next),
              label: const Text('Gallery (No Crop)'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Shows a preview of the cropped image before uploading
  Future<bool> _showImagePreviewDialog(File croppedImage) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Preview Profile Picture'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('This is how your profile picture will look:'),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppConstants.primaryColor,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.file(
                        croppedImage,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  const Text(
                    'Do you want to proceed with this image?',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Crop Again'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Use This Image'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// Shows a dialog when cropping fails, asking user if they want to use original image
  Future<bool> _showCropErrorDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cropping Failed'),
              content: const Text(
                'Image cropping failed. Would you like to use the original image instead?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Use Original'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _pickAndUpdateImage() async {
    try {
      // Show source selection dialog
      final ImageSelectionOption? option = await _showImageSourceDialog();
      if (option == null) return;

      // Determine the actual image source
      final ImageSource source =
          option == ImageSelectionOption.camera
              ? ImageSource.camera
              : ImageSource.gallery;

      // Determine if we should skip cropping
      final bool skipCropping = option == ImageSelectionOption.galleryNoCrop;

      XFile? pickedImage;
      try {
        pickedImage = await _imagePicker.pickImage(
          source: source,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 80,
        );
      } catch (pickerError) {
        print('❌ Image picker error: $pickerError');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $pickerError'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      if (pickedImage != null) {
        print('📸 Image selected: ${pickedImage.path}');
        print('📸 Image name: ${pickedImage.name}');
        print('📸 Image size: ${await File(pickedImage.path).length()} bytes');

        // Check if the image format is supported
        final imageFile = File(pickedImage.path);
        if (!await imageFile.exists()) {
          print('❌ Selected image file does not exist');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selected image file is not accessible'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Check image format
        final String imagePath = pickedImage.path.toLowerCase();
        if (!imagePath.endsWith('.jpg') &&
            !imagePath.endsWith('.jpeg') &&
            !imagePath.endsWith('.png') &&
            !imagePath.endsWith('.webp')) {
          print('⚠️ Unsupported image format: ${pickedImage.name}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Unsupported image format: ${pickedImage.name}\nPlease select JPG, PNG, or WebP.',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
          return;
        }

        // Validate image can be read
        try {
          final imageBytes = await imageFile.readAsBytes();
          if (imageBytes.isEmpty) {
            throw Exception('Image file is empty');
          }
          print('✅ Image validation passed: ${imageBytes.length} bytes');
        } catch (validationError) {
          print('❌ Image validation failed: $validationError');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Selected image is corrupted or cannot be read.\nPlease try another image.',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
          return;
        }

        setState(() {
          _isLoading = true;
        });

        try {
          // Crop the selected image (unless skipping cropping)
          print('🔄 Starting image processing for: ${pickedImage.path}');
          File? croppedImage;

          if (skipCropping) {
            // Skip cropping and use original image
            croppedImage = File(pickedImage.path);
            print('⏭️ Skipping cropping, using original image');
          } else {
            // Perform cropping
            try {
              croppedImage = await _cropImage(pickedImage.path);
            } catch (cropError) {
              print('❌ Image cropping failed: $cropError');
              // Show dialog to ask user if they want to use original image
              if (mounted) {
                final useOriginal = await _showCropErrorDialog();
                if (useOriginal) {
                  // Use original image without cropping
                  croppedImage = File(pickedImage.path);
                  print('✅ Using original image without cropping');
                } else {
                  setState(() {
                    _isLoading = false;
                  });
                  return;
                }
              }
            }
          }

          if (croppedImage == null) {
            // User cancelled cropping
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image cropping was cancelled'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          print('✅ Image processed successfully: ${croppedImage.path}');

          // Store the old photo URL to delete it later
          final oldPhotoUrl = _userData?['photoUrl'];

          // Show preview of cropped image
          if (mounted) {
            final shouldProceed = await _showImagePreviewDialog(croppedImage);
            if (!shouldProceed) {
              setState(() {
                _isLoading = false;
              });
              return;
            }
          }

          // Validate cropped image file
          if (!await croppedImage.exists()) {
            throw Exception('Cropped image file does not exist');
          }

          // Check file size (max 5MB)
          final fileSize = await croppedImage.length();
          if (fileSize > 5 * 1024 * 1024) {
            throw Exception('Image file is too large. Maximum size is 5MB.');
          }

          // Upload image to Firebase Storage with unique filename
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final fileName = 'profile_${_userId}_$timestamp.jpg';
          final storageRef = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('users/profile_images/$fileName');

          // Upload the cropped file with progress tracking
          final uploadTask = storageRef.putFile(croppedImage);

          // Listen to upload progress
          uploadTask.snapshotEvents.listen((snapshot) {
            setState(() {
              _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
            });
          });

          // Wait for upload to complete
          final snapshot = await uploadTask;

          // Get the download URL
          final downloadURL = await snapshot.ref.getDownloadURL();

          // Update local data with the download URL
          _userData!['photoUrl'] = downloadURL;

          // Reset upload progress
          _uploadProgress = 0.0;

          // Clean up temporary cropped file
          try {
            if (await croppedImage.exists()) {
              await croppedImage.delete();
              print('✅ Temporary cropped image cleaned up');
            }
          } catch (cleanupError) {
            print(
              '⚠️ Warning: Could not clean up temporary file: $cleanupError',
            );
          }

          // Update the UI
          setState(() {});

          // Delete the old profile image if it exists and is from Firebase Storage
          if (oldPhotoUrl != null &&
              oldPhotoUrl.isNotEmpty &&
              oldPhotoUrl.startsWith('http') &&
              oldPhotoUrl.contains('firebasestorage.googleapis.com')) {
            try {
              await _deleteOldProfileImage(oldPhotoUrl);
              print('✅ Old profile image deleted successfully');
            } catch (deleteError) {
              print(
                '⚠️ Warning: Could not delete old profile image: $deleteError',
              );
              // Continue even if deletion fails
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile image uploaded successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Send notification about profile image update
          await _sendNotification(
            title: 'Profile Picture Updated',
            body: 'Your profile picture has been updated successfully!',
            data: {
              'type': 'profile_image_update',
              'action': 'image_uploaded',
              'userId': _userId ?? '',
            },
          );

          print('✅ Profile image uploaded to Firebase Storage: $downloadURL');
        } catch (uploadError) {
          print('❌ Error uploading image to Firebase Storage: $uploadError');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error uploading image: $uploadError'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  /// Resizes an image if it's too large
  Future<File?> _resizeImageIfNeeded(File imageFile) async {
    try {
      final int fileSize = await imageFile.length();
      final int maxSize = 5 * 1024 * 1024; // 5MB

      if (fileSize <= maxSize) {
        return imageFile; // No need to resize
      }

      print('🔄 Image is too large ($fileSize bytes), resizing...');

      // For now, just return the original file
      // In a production app, you might want to add actual image resizing
      // using packages like image or flutter_image_compress
      print('⚠️ Image resizing not implemented, using original file');
      return imageFile;
    } catch (e) {
      print('❌ Error resizing image: $e');
      return imageFile; // Return original on error
    }
  }

  /// Crops the selected image to a square aspect ratio
  Future<File?> _cropImage(String imagePath) async {
    try {
      print('🔄 Cropping image: $imagePath');

      // Check if the image file exists
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        print('❌ Image file does not exist: $imagePath');
        throw Exception('Image file does not exist');
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ), // Square aspect ratio
        compressQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: AppConstants.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
            showCropGrid: true,
          ),
          IOSUiSettings(
            title: 'Crop Profile Picture',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
            resetAspectRatioEnabled: false,
            rotateButtonsHidden: true,
            rotateClockwiseButtonHidden: true,
            doneButtonTitle: 'Done',
            cancelButtonTitle: 'Cancel',
          ),
        ],
      );

      if (croppedFile != null) {
        print('✅ Image cropped successfully');
        return File(croppedFile.path);
      } else {
        print('⚠️ Image cropping cancelled by user');
        return null;
      }
    } catch (e) {
      print('❌ Error cropping image: $e');
      return null;
    }
  }

  /// Deletes an old profile image from Firebase Storage
  Future<void> _deleteOldProfileImage(String imageUrl) async {
    try {
      // Extract the file path from the Firebase Storage URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Find the storage path (usually after 'o' segment)
      final oIndex = pathSegments.indexOf('o');
      if (oIndex != -1 && oIndex + 1 < pathSegments.length) {
        final storagePath = pathSegments.sublist(oIndex + 1).join('/');

        // Decode the URL-encoded path
        final decodedPath = Uri.decodeComponent(storagePath);

        // Create a reference to the file and delete it
        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child(decodedPath);
        await storageRef.delete();

        print(
          '✅ Old profile image deleted from Firebase Storage: $decodedPath',
        );
      }
    } catch (e) {
      print('❌ Error deleting old profile image: $e');
      rethrow;
    }
  }

  /// Sends a notification using the send_notification_services
  Future<void> _sendNotification({
    required String title,
    required String body,
    Map<String, String>? data,
    String? token,
  }) async {
    try {
      print(
        '📱 ProfilePage: Sending notification - Title: $title, Body: $body',
      );

      await sendNotification(
        token:
            token ?? 'default_token', // You can pass a specific FCM token here
        title: title,
        body: body,
        data:
            data ??
            {
              'type': 'profile_update',
              'userId': _userId ?? '',
              'timestamp': DateTime.now().toIso8601String(),
            },
      );

      print('✅ ProfilePage: Notification sent successfully');
    } catch (e) {
      print('❌ ProfilePage: Error sending notification: $e');
      // Don't show error to user for notification failures
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
          'photoUrl': _userData?['photoUrl'] ?? '', // Include photo URL
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

        // Send notification about profile update
        await _sendNotification(
          title: 'Profile Updated',
          body: 'Your profile has been updated successfully!',
          data: {
            'type': 'profile_update',
            'action': 'profile_saved',
            'userId': _userId ?? '',
          },
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

      // Send notification about logout
      await _sendNotification(
        title: 'Logged Out',
        body: 'You have been logged out successfully',
        data: {
          'type': 'user_logout',
          'action': 'logout_success',
          'userId': _userId ?? '',
        },
      );

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

                            // Upload progress indicator
                            if (_isEditing &&
                                _uploadProgress > 0.0 &&
                                _uploadProgress < 1.0) ...[
                              const SizedBox(height: AppConstants.paddingSmall),
                              Container(
                                width: 120,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: LinearProgressIndicator(
                                  value: _uploadProgress,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppConstants.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppConstants.paddingSmall),
                              Text(
                                'Uploading... ${(_uploadProgress * 100).toInt()}%',
                                style: AppConstants.captionStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],

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
