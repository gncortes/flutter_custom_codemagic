class AddDirectoryInput {
  final String path;

  AddDirectoryInput({
    required this.path,
  }) : assert(path.isNotEmpty, 'The path cannot be empty');
}
