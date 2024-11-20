class DirectoryModel {
  final int id;
  final String path;
  final String createdAt;
  final String updatedAt;

  const DirectoryModel._({
    required this.id,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DirectoryModel.fromJson(Map<String, dynamic> json) {
    return DirectoryModel._(
      id: json['id'],
      path: json['path'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
