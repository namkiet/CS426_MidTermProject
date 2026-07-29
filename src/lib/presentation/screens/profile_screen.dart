import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_code_cup/core/constants/app_colors.dart';
import 'package:the_code_cup/presentation/viewmodels/profile_viewmodel.dart';
import 'package:the_code_cup/presentation/viewmodels/ui_models.dart';
import 'package:the_code_cup/presentation/widgets/app_chrome.dart';
import 'package:the_code_cup/presentation/widgets/common_blocks.dart';

enum _Field { name, phone, email, address }

class ProfileScreen extends StatefulWidget {
  final ProfileViewModel viewModel;
  final ValueChanged<int> onTabSelected;

  const ProfileScreen({
    super.key,
    required this.viewModel,
    required this.onTabSelected,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _Field? _editing;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start(_Field field, String value) {
    setState(() {
      _editing = field;
      _controller.text = value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    });
  }

  Future<void> _save() async {
    final value = _controller.text.trim();
    final editing = _editing;
    if (editing == null) return;
    final error = await switch (editing) {
      _Field.name => widget.viewModel.updateName(value),
      _Field.phone => widget.viewModel.updatePhone(value),
      _Field.email => widget.viewModel.updateEmail(value),
      _Field.address => widget.viewModel.updateAddress(value),
    };
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _editing = null);
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    await widget.viewModel.updateAvatar(
      'data:image/png;base64,${base64Encode(bytes)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) => ScreenTemplate(
        appBar: createAppBar(),
        navigationBar: createNavigationBar(onTabSelected: widget.onTabSelected),
        body: createBody(
          profile: widget.viewModel.profile,
          editing: _editing,
          controller: _controller,
          onPickImage: _pickImage,
          onStartEdit: _start,
          onCancelEdit: () => setState(() => _editing = null),
          onSave: _save,
        ),
      ),
    );
  }

  static PreferredSizeWidget createAppBar() =>
      const AppAppBar(title: 'Profile');

  static Widget createNavigationBar({
    required ValueChanged<int> onTabSelected,
  }) =>
      AppBottomNav(currentIndex: 3, onTabSelected: onTabSelected);

  static ImageProvider? avatarImage(ProfileUi profile) {
    final url = profile.avatarUrl;
    if (url == null) return null;
    if (url.startsWith('data:')) {
      return MemoryImage(base64Decode(url.split(',').last));
    }
    if (url.startsWith('blob:')) return null;
    return NetworkImage(url);
  }

  static Widget createBody({
    required ProfileUi profile,
    required _Field? editing,
    required TextEditingController controller,
    required VoidCallback onPickImage,
    required void Function(_Field field, String value) onStartEdit,
    required VoidCallback onCancelEdit,
    required VoidCallback onSave,
  }) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      children: [
        Center(
          child: GestureDetector(
            onTap: onPickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.surface,
                  backgroundImage: avatarImage(profile),
                  child: profile.avatarUrl == null
                      ? Text(
                          profile.initial,
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
        ProfileFieldRow(
          icon: Icons.person_outline,
          label: 'Full name',
          value: profile.name,
          isEditing: editing == _Field.name,
          controller: controller,
          onEdit: () => onStartEdit(_Field.name, profile.name),
          onCancel: onCancelEdit,
          onSave: onSave,
        ),
        const SizedBox(height: 24),
        ProfileFieldRow(
          icon: Icons.phone_outlined,
          label: 'Phone number',
          value: profile.phone,
          isEditing: editing == _Field.phone,
          controller: controller,
          onEdit: () => onStartEdit(_Field.phone, profile.phone),
          onCancel: onCancelEdit,
          onSave: onSave,
        ),
        const SizedBox(height: 24),
        ProfileFieldRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: profile.email,
          isEditing: editing == _Field.email,
          controller: controller,
          onEdit: () => onStartEdit(_Field.email, profile.email),
          onCancel: onCancelEdit,
          onSave: onSave,
        ),
        const SizedBox(height: 24),
        ProfileFieldRow(
          icon: Icons.location_on_outlined,
          label: 'Address',
          value: profile.address,
          isEditing: editing == _Field.address,
          controller: controller,
          onEdit: () => onStartEdit(_Field.address, profile.address),
          onCancel: onCancelEdit,
          onSave: onSave,
        ),
      ],
    );
  }
}
