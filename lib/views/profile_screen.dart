import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/models/user_profile.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/widgets/app_shell.dart';

class ProfileScreen extends StatefulWidget {
  final HomeViewModel viewModel;

  const ProfileScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? _editingIndex;
  late TextEditingController _controller;
  late UserProfile _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.viewModel.userProfile;
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startEditing(int index, String currentValue) {
    setState(() {
      _editingIndex = index;
      _controller.text = currentValue;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: currentValue.length),
      );
    });
  }

  void _saveEdit() {
    final value = _controller.text.trim();
    final error = widget.viewModel.updateProfileField(_editingIndex!, value);
    if (error != null) {
      _showWarning(error);
      return;
    }
    setState(() {
      _draft = widget.viewModel.userProfile;
      _editingIndex = null;
    });
  }

  void _cancelEdit() {
    setState(() => _editingIndex = null);
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    widget.viewModel.updateProfileField(4, file.path);
    setState(() => _draft = widget.viewModel.userProfile);
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 3,
      userProfile: widget.viewModel.userProfile,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.surface,
                    backgroundImage: _draft.avatarUrl != null
                        ? FileImage(File(_draft.avatarUrl!))
                        : null,
                    child: _draft.avatarUrl == null
                        ? Text(
                            _draft.name.isNotEmpty
                                ? _draft.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildField(
            index: 0,
            icon: Icons.person_outline,
            label: 'Full name',
            value: _draft.name,
          ),
          const SizedBox(height: 24),
          _buildField(
            index: 1,
            icon: Icons.phone_outlined,
            label: 'Phone number',
            value: _draft.phone ?? '',
          ),
          const SizedBox(height: 24),
          _buildField(
            index: 2,
            icon: Icons.email_outlined,
            label: 'Email',
            value: _draft.email,
          ),
          const SizedBox(height: 24),
          _buildField(
            index: 3,
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: _draft.address ??
                '3 Addersion Court, Chino Hills, HO56824, United State',
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required int index,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isEditing = _editingIndex == index;

    if (isEditing) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                TextField(
                  controller: _controller,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _cancelEdit,
            child: const Icon(Icons.close, color: AppColors.textSecondary, size: 24),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _saveEdit,
            child: const Icon(Icons.check, color: AppColors.activeIcon, size: 24),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          color: AppColors.textPrimary,
          onPressed: () => _startEditing(index, value),
        ),
      ],
    );
  }
}
