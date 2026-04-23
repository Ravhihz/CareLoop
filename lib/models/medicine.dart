class Medicine {
  final int? id;
  final int illnessId;
  final String name;
  final int stock;
  final int frequency;
  final List<String> times;

  Medicine({
    this.id,
    required this.illnessId,
    required this.name,
    required this.stock,
    required this.frequency,
    required this.times,
  });

  Medicine copyWith({
    int? id,
    int? illnessId,
    String? name,
    int? stock,
    int? frequency,
    List<String>? times,
  }) {
    return Medicine(
      id: id ?? this.id,
      illnessId: illnessId ?? this.illnessId,
      name: name ?? this.name,
      stock: stock ?? this.stock,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'illness_id': illnessId,
      'name': name,
      'stock': stock,
      'frequency': frequency,
      'times': times.join(','),
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      illnessId: map['illness_id'],
      name: map['name'],
      stock: map['stock'],
      frequency: map['frequency'],
      times: (map['times'] as String).split(','),
    );
  }
}
