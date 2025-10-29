import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/species.dart';
import '../providers/species_provider.dart';

class AddSpeciesScreen extends StatefulWidget {
  static const routeName = '/add';
  const AddSpeciesScreen({super.key});

  @override
  State<AddSpeciesScreen> createState() => _AddSpeciesScreenState();
}

class _AddSpeciesScreenState extends State<AddSpeciesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  String _imagePath = '';

  // Controllers
  final domain = TextEditingController();
  final kingdom = TextEditingController();
  final phylum = TextEditingController();
  final className = TextEditingController();
  final orderName = TextEditingController();
  final family = TextEditingController();
  final genus = TextEditingController();
  final species = TextEditingController();
  final name = TextEditingController();

  @override
  void dispose() {
    domain.dispose();
    kingdom.dispose();
    phylum.dispose();
    className.dispose();
    orderName.dispose();
    family.dispose();
    genus.dispose();
    species.dispose();
    name.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _imagePath = file.path);
    }
  }

  InputDecoration _input(String label) => InputDecoration(labelText: label);

  List<TextInputFormatter> get _allowLettersDot => [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zก-ฮ\s\.]')),
  ];

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final newS = Species(
      imagePath: _imagePath,
      name: name.text.trim(),
      domain: domain.text.trim(),
      kingdom: kingdom.text.trim(),
      phylum: phylum.text.trim(),
      className: className.text.trim(),
      orderName: orderName.text.trim(),
      family: family.text.trim(),
      genus: genus.text.trim(),
      species: species.text.trim(),
    );
    final p = context.read<SpeciesProvider>();
    await p.addSpecies(newS);
    await p.loadSpecies();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = _imagePath.isEmpty
        ? Container(
            height: 180,
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: const Text('แตะเพื่อเลือกรูปจากภายใน'),
          )
        : Image.file(File(_imagePath), height: 180, fit: BoxFit.cover);

    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มสายพันธุ์')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageWidget,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: name,
              decoration: _input('ชื่อ (Name)'),
              inputFormatters: _allowLettersDot,
              validator: (v) => v!.isEmpty ? 'กรอกชื่อ' : null,
            ),
            TextFormField(
              controller: domain,
              decoration: _input('โดเมน (Domain)'),
              inputFormatters: _allowLettersDot,
              validator: (v) => v!.isEmpty ? 'กรอกโดเมน' : null,
            ),
            TextFormField(
              controller: kingdom,
              decoration: _input('อาณาจักร (Kingdom)'),
              inputFormatters: _allowLettersDot,
              validator: (v) => v!.isEmpty ? 'กรอกอาณาจักร' : null,
            ),
            TextFormField(
              controller: phylum,
              decoration: _input('ไฟลัม (Phylum)'),
              inputFormatters: _allowLettersDot,
              validator: (v) => v!.isEmpty ? 'กรอกไฟลัม' : null,
            ),
            TextFormField(
              controller: className,
              decoration: _input('ชั้น (Class)'),
              inputFormatters: _allowLettersDot,
              validator: (v) => v!.isEmpty ? 'กรอกชั้น' : null,
            ),
            TextFormField(
              controller: orderName,
              decoration: _input('อันดับ (Order)'),
              inputFormatters: _allowLettersDot,
              validator: (v) => v!.isEmpty ? 'กรอกอันดับ' : null,
            ),
            TextFormField(
              controller: family,
              decoration: _input('วงศ์ (Family)'),
              inputFormatters: _allowLettersDot,
              validator: (v) => v!.isEmpty ? 'กรอกวงศ์' : null,
            ),
            TextFormField(
              controller: genus,
              decoration: _input('สกุล (Genus)'),
              inputFormatters: _allowLettersDot,
              validator: (v) => v!.isEmpty ? 'กรอกสกุล' : null,
            ),
            TextFormField(
              controller: species,
              decoration: _input('สปีชีส์ (Species)'),
              inputFormatters: _allowLettersDot,
              validator: (v) => v!.isEmpty ? 'กรอกสปีชีส์' : null,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}
