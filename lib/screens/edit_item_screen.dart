import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/constants.dart';

/// Screen for editing an existing [ClothingItem].  It mirrors the
/// functionality of [AddItemScreen] but pre‑populates the form fields
/// with the item's current values and saves updates via the provider.
class EditItemScreen extends ConsumerStatefulWidget {
  const EditItemScreen({super.key, required this.item});

  final ClothingItem item;

  @override
  ConsumerState<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late final TextEditingController _colorController;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _typeController = TextEditingController(text: widget.item.type);
    _colorController = TextEditingController(text: widget.item.color);
    if (widget.item.imagePath.isNotEmpty) {
      _selectedImage = File(widget.item.imagePath);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, maxWidth: 600);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final updated = ClothingItem(
      id: widget.item.id,
      name: _nameController.text.trim(),
      type: _typeController.text.trim(),
      color: _colorController.text.trim(),
      imagePath: _selectedImage?.path ?? '',
      inWash: widget.item.inWash,
      isAvailable: widget.item.isAvailable,
    );
    await ref.read(wardrobeProvider.notifier).updateItem(updated);
    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) => SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Take Photo'),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              _pickImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Choose from Gallery'),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt_outlined, size: 48.0, color: Colors.grey),
                            SizedBox(height: 8.0),
                            Text('Tap to add photo', style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            _selectedImage!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              DropdownButtonFormField<String>(
                value: _typeController.text.isNotEmpty ? _typeController.text : null,
                items: [
                  for (final type in ClothesData.types)
                    DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                ],
                onChanged: (val) {
                  setState(() {
                    _typeController.text = val ?? '';
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please select a type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              DropdownButtonFormField<String>(
                value: _colorController.text.isNotEmpty ? _colorController.text : null,
                items: [
                  for (final colour in ClothesData.colours)
                    DropdownMenuItem<String>(
                      value: colour,
                      child: Text(colour),
                    ),
                ],
                onChanged: (val) {
                  setState(() {
                    _colorController.text = val ?? '';
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Colour',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please select a colour';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveItem,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
