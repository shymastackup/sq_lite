import 'package:flutter/material.dart';
import 'package:sq_lite_application1/databasehelper.dart';



class ContactProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _contacts = [];

  List<Map<String, dynamic>> get contacts => _contacts;

  Future<void> loadContacts() async {
    _contacts = await _dbHelper.getContacts();
    notifyListeners();
  }

  Future<void> addContact(String name, String phone) async {
    await _dbHelper.addContact(name, phone);
    await loadContacts();
  }

  Future<void> updateContact(int id, String name, String phone) async {
    await _dbHelper.updateContact(id, name, phone);
    await loadContacts();
  }

  Future<void> deleteContact(int id) async {
    await _dbHelper.deleteContact(id);
    await loadContacts();
  }
}
