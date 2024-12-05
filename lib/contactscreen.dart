import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sq_lite_application1/contactprovider.dart';

class AddContactScreen extends StatefulWidget {
  final Map<String, dynamic>? contact;

  const AddContactScreen({this.contact, super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!['name'];
      _phoneController.text = widget.contact!['phone'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider =
        Provider.of<ContactProvider>(context, listen: false);
    final isEditing = widget.contact != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Contact' : 'Add Contact'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contact Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter a name'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value == null || !RegExp(r'^\d{10}$').hasMatch(value)
                          ? 'Please enter a valid 10-digit phone number'
                          : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (isEditing) {
                          contactProvider.updateContact(
                            widget.contact!['id'],
                            _nameController.text.trim(),
                            _phoneController.text.trim(),
                          );
                          _showSnackBar(
                              context, 'Contact updated successfully!');
                        } else {
                          contactProvider.addContact(
                            _nameController.text.trim(),
                            _phoneController.text.trim(),
                          );
                          _showSnackBar(context, 'Contact added successfully!');
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      isEditing ? 'Update Contact' : 'Save Contact',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
