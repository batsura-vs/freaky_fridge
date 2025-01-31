class AllergenDTO {
  final String name;
  final String severity;
  final String description;

  AllergenDTO({
    required this.name,
    required this.severity,
    required this.description,
  });

  factory AllergenDTO.fromXml(Map<String, String?> attributes) {
    return AllergenDTO(
      name: attributes['name'] ?? '',
      severity: attributes['severity'] ?? 'medium',
      description: attributes['description'] ?? '',
    );
  }

  factory AllergenDTO.fromJson(Map<String, dynamic> json) {
    return AllergenDTO(
      name: json['name'] as String? ?? '',
      severity: json['severity'] as String? ?? 'medium',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'severity': severity,
      'description': description,
    };
  }
} 