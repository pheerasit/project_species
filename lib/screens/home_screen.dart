import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/species_provider.dart';
import '../models/species.dart';
import 'add_species_screen.dart';
import 'edit_species_screen.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<SpeciesProvider>(context, listen: false).loadSpecies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SpeciesProvider>();
    final items = p.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('บันทึกสายพันธุ์สิ่งมีชีวิต'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () =>
                Navigator.pushNamed(context, CategoryScreen.routeName),
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('ยังไม่มีข้อมูลสายพันธุ์'))
          : RefreshIndicator(
              onRefresh: p.loadSpecies,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final s = items[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: s.imagePath.isNotEmpty
                          ? CircleAvatar(
                              radius: 28,
                              backgroundImage: FileImage(File(s.imagePath)),
                            )
                          : const CircleAvatar(
                              radius: 28,
                              child: Icon(Icons.image_not_supported),
                            ),
                      title: Text(s.species),
                      subtitle: Text('${s.genus} (${s.kingdom})'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('ยืนยันการลบ'),
                              content: Text(
                                'ต้องการลบ "${s.species}" หรือไม่?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('ลบ'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true) await p.deleteSpecies(s.id!);
                        },
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditSpeciesScreen(initial: s),
                          ),
                        );
                        await p.loadSpecies();
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, AddSpeciesScreen.routeName);
          await p.loadSpecies();
        },
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มสายพันธุ์'),
      ),
    );
  }
}
