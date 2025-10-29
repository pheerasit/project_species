class Species {
  final int? id;
  final String imagePath;
  
  final String domain;
  final String kingdom;
  final String phylum;
  final String className;
  final String orderName;
  final String family;
  final String genus;
  final String species;
  final String name;
  
  Species({
    this.id,
    required this.imagePath,
    required this.domain,
    required this.kingdom,
    required this.phylum,
    required this.className,
    required this.orderName,
    required this.family,
    required this.genus,
    required this.species,
    required this.name,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'imagePath': imagePath,
    'domain': domain,
    'kingdom': kingdom,
    'phylum': phylum,
    'className': className,
    'orderName': orderName,
    'family': family,
    'genus': genus,
    'species': species,
    'name': name,
  };

  factory Species.fromMap(Map<String, dynamic> map) => Species(
    id: map['id'] as int?,
    imagePath: (map['imagePath'] ?? '') as String,
    domain: map['domain'] ?? '',
    kingdom: map['kingdom'] ?? '',
    phylum: map['phylum'] ?? '',
    className: map['className'] ?? '',
    orderName: map['orderName'] ?? '',
    family: map['family'] ?? '',
    genus: map['genus'] ?? '',
    species: map['species'] ?? '',
    name: map['name'] ?? '',
  );
  Species copyWith({
    int? id,
    String? imagePath,
    String? domain,
    String? kingdom,
    String? phylum,
    String? className,
    String? orderName,
    String? family,
    String? genus,
    String? species,
    String? name,
  }) {
    return Species(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      domain: domain ?? this.domain,
      kingdom: kingdom ?? this.kingdom,
      phylum: phylum ?? this.phylum,
      className: className ?? this.className,
      orderName: orderName ?? this.orderName,
      family: family ?? this.family,
      genus: genus ?? this.genus,
      species: species ?? this.species,
      name: name ?? this.name,
    );
  }
}
