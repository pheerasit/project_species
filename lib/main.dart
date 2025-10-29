import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/species_provider.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';
import 'screens/add_species_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => SpeciesProvider()..loadSpecies(),
      child: const SpeciesApp(),
    ),
  );
}

class SpeciesApp extends StatelessWidget {
  const SpeciesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Species (สายพันธุ์สิ่งมีชีวิต)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      routes: {
        '/': (_) => const HomeScreen(),
        CategoryScreen.routeName: (_) => const CategoryScreen(),
        AddSpeciesScreen.routeName: (_) => const AddSpeciesScreen(),
      },
    );
  }
}
