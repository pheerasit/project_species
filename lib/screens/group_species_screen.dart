import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/species_provider.dart';
import '../models/species.dart';

class GroupSpeciesScreen extends StatelessWidget {
  final String column;
  final String value;
  const GroupSpeciesScreen({
    super.key,
    required this.column,
    required this.value,
  });

  String get title {
    final map = {
      'name': 'ชื่อ',
      'domain': 'โดเมน',
      'kingdom': 'อาณาจักร',
      'phylum': 'ไฟลัม',
      'className': 'ชั้น',
      'orderName': 'อันดับ',
      'family': 'วงศ์',
      'genus': 'สกุล',
      'species': 'สปีชีส์',
    };
    return '${map[column] ?? column}: $value';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SpeciesProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<Species>>(
        future: provider.whereEquals(column, value),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }

          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('ไม่พบรายการในหมวดนี้'));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final s = list[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  title: Text(
                    s.species,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${s.genus} (${s.kingdom})'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
