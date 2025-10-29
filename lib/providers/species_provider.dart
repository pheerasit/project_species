import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/species.dart';

class SpeciesProvider extends ChangeNotifier {
  final db = DatabaseHelper.instance;
  List<Species> _items = [];

  List<Species> get items => _items;

  Future<void> loadSpecies() async {
    _items = await db.getAll();
    notifyListeners();
  }

  Future<void> addSpecies(Species s) async {
    await db.insert(s);
    _items = await db.getAll();
    notifyListeners();
  }

  Future<void> updateSpecies(Species s) async {
    await db.update(s);
    _items = await db.getAll();
    notifyListeners();
  }

  Future<void> deleteSpecies(int id) async {
    await db.delete(id);
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<List<String>> distinctBy(String column) => db.distinct(column);
  Future<List<Species>> whereEquals(String column, String value) =>
      db.whereEquals(column, value);
}
