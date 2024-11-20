class DirectoryEntity {
  final int id;
  final String path;
  final DateTime createdAt;
  final DateTime updatedAt;

  DirectoryEntity({
    required this.id,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(path.isNotEmpty, 'The path cannot be empty');
}
