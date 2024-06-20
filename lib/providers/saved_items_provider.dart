import 'package:flutter/material.dart';

class SavedItemsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _savedItems = [];

  List<Map<String, dynamic>> get savedItems => _savedItems;

  void addSavedItem(Map<String, dynamic> item) {
    if (!_savedItems.contains(item)) {
      _savedItems.add(item);
      notifyListeners();
    }
  }

  void removeSavedItem(Map<String, dynamic> item) {
    if (_savedItems.contains(item)) {
      _savedItems.remove(item);
      notifyListeners();
    }
  }

  bool isSaved(Map<String, dynamic> item) {
    return _savedItems.contains(item);
  }
}
