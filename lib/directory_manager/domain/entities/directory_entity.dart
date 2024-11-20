class DirectoryEntity {
  final int id;
  final String path;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DirectoryEntity({
    required this.id,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
  });
}
