import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/helper/images/image_display.dart';
import '../../../core/configs/theme/app_colors.dart';
import 'home.dart'; // Import the Home page

class ProfilePicturePage extends StatefulWidget {
  final String userId; // Pass the userId from the previous screen

  const ProfilePicturePage({super.key, required this.userId});

  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  File? _image;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage(widget.userId);
  }

  // Load the user's profile image from Firebase
  Future<void> _loadProfileImage(String userId) async {
    try {
      // Get the reference to the image in Firebase Storage
      final refStorage = FirebaseStorage.instance.ref("Users/Images/$userId.jpg");
      final downloadUrl = await refStorage.getDownloadURL();
      setState(() {
        _profileImageUrl = downloadUrl; // Store the download URL to display later
      });
    } catch (e) {
      ("Image not found, using default: $e");
      // Image doesn't exist, use default image
      setState(() {
        _profileImageUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Picture'),
        centerTitle: true,
        elevation: 1,
        backgroundColor: AppColors.secondBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _profilePicture(context),
              const SizedBox(height: 30),
              _actionButtons(context, widget.userId),
              const SizedBox(height: 20),
              _finishedButton(context), // Add Finished button
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display the profile picture
  Widget _profilePicture(BuildContext context) {
    return CircleAvatar(
      radius: 80,
      backgroundImage: _image != null
          ? FileImage(_image!) // Show the selected image if picked
          : _profileImageUrl != null
          ? NetworkImage(_profileImageUrl!) // Show the Firebase image if it exists
          : NetworkImage(ImageDisplayHelper.generateUserImageURL('default_profile.png')), // Fallback to default image
      backgroundColor: Colors.grey,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black54, // Slight transparency for better contrast
          ),
          child: IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: _pickImage,
          ),
        ),
      ),
    );
  }

  // Widget for buttons with improved padding and alignment
  Widget _actionButtons(BuildContext context, String userId) {
    return Column(
      children: [
        _editButton(context, userId),
        const SizedBox(height: 15),
        _deleteButton(context, userId), // Pass userId to delete button
      ],
    );
  }

  // Edit button widget
  Widget _editButton(BuildContext context, String userId) {
    return ElevatedButton.icon(
      onPressed: () {
        if (_image != null) {
          _uploadImage(userId); // Upload image when the edit button is pressed
        } else {
          ("No image selected");
          // Show a message to the user if no image is selected
        }
      },
      icon: const Icon(Icons.edit),
      label: const Text('Confirm Edit'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 50), // Full-width button
      ),
    );
  }

  // Delete button widget
  Widget _deleteButton(BuildContext context, String userId) {
    return ElevatedButton.icon(
      onPressed: () async {
        await _deleteImage(userId); // Call the delete function
      },
      icon: const Icon(Icons.delete),
      label: const Text('Delete'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 50), // Full-width button
        backgroundColor: Colors.red,
      ),
    );
  }

  // "Finished" button widget
  Widget _finishedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the Home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), // Replace with HomePage
        );
      },
      child: const Text('Finished'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 50), // Full-width button
        backgroundColor: Colors.green, // Set the button color
      ),
    );
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Upload image to Firebase
  Future<void> _uploadImage(String userId) async {
    try {
      // Create a reference to Firebase Storage using the userId
      var refStorage = FirebaseStorage.instance.ref("Users/Images/$userId.jpg");

      // Set metadata (even if optional, it avoids null metadata)
      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg', // Specify the content type
        cacheControl: 'public, max-age=31536000', // Optional, set cache control if needed
      );

      // Upload the file with metadata
      await refStorage.putFile(_image!, metadata);

      // Get the download URL if needed
      String downloadUrl = await refStorage.getDownloadURL();
      ("Upload successful! Download URL: $downloadUrl");

      // Update the displayed image with the uploaded one
      setState(() {
        _profileImageUrl = downloadUrl;
      });
    } catch (e) {
      ("Upload failed: $e");
      // Handle any error (show a message to the user, etc.)
    }
  }

  // Delete image from Firebase
  Future<void> _deleteImage(String userId) async {
    try {
      // Create a reference to the image in Firebase Storage using the userId
      var refStorage = FirebaseStorage.instance.ref("Users/Images/$userId.jpg");

      // Delete the image
      await refStorage.delete();
      ("Image deleted successfully!");

      // Reset the profile image URL to null
      setState(() {
        _profileImageUrl = null;
        _image = null; // Clear the displayed image
      });
    } catch (e) {
      ("Delete failed: $e");
      // Handle any error (show a message to the user, etc.)
    }
  }
}
