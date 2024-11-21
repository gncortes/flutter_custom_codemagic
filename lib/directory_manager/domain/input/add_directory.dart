class AddDirectoryInput {
  final String path;

  AddDirectoryInput(this.path)
      : assert(path.isNotEmpty, 'The path cannot be empty');
}
