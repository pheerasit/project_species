import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/species_provider.dart';
import 'group_species_screen.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/categories';
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = const [
      ['โดเมน (Domain)', 'domain'],
      ['อาณาจักร (Kingdom)', 'kingdom'],
      ['ไฟลัม (Phylum)', 'phylum'],
      ['ชั้น (Class)', 'className'],
      ['อันดับ (Order)', 'orderName'],
      ['วงศ์ (Family)', 'family'],
      ['สกุล (Genus)', 'genus'],
      ['สปีชีส์ (Species)', 'species'],
      ['ชื่อ (Name)', 'name'],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('หมวดหมู่สายพันธุ์')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final title = categories[i][0] as String;
          final column = categories[i][1] as String;
          return _CategoryTile(title: title, column: column);
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String title;
  final String column;

  const _CategoryTile({required this.title, required this.column});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SpeciesProvider>();

    return FutureBuilder<List<String>>(
      future: provider.distinctBy(column),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }

        final values = snapshot.data ?? [];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ExpansionTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${values.length} รายการ',
              style: const TextStyle(fontSize: 13),
            ),
            children: values.isEmpty
                ? [const ListTile(title: Text('ยังไม่มีข้อมูลในหมวดนี้'))]
                : values
                      .map(
                        (v) => ListTile(
                          title: Text(v),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GroupSpeciesScreen(
                                  column: column,
                                  value: v,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
          ),
        );
      },
    );
  }
}
