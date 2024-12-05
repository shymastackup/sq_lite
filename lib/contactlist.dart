import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sq_lite_application1/contactprovider.dart';
import 'package:sq_lite_application1/contactscreen.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);

    // Load contacts when the screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      contactProvider.loadContacts();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: true,
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) {
          final contacts = provider.contacts;

          if (contacts.isEmpty) {
            return const Center(
              child: Text(
                'No contacts found.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12.0),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      contact['name'][0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    contact['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    contact['phone'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddContactScreen(contact: contact),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _confirmDelete(context, provider, contact['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: 8), // Adds spacing between cards
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContactScreen()),
          );
        },
        tooltip: 'Add Contact',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, ContactProvider provider, int contactId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Contact',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this contact?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                provider.deleteContact(contactId);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
