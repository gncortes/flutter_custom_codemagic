class UpdateDirectoryInput {
  final int id;
  final String path;

  UpdateDirectoryInput({
    required this.path,
    required this.id,
  })  : assert(path.isNotEmpty, 'The path cannot be empty'),
        assert(id > 0, 'Invalid id');
}
