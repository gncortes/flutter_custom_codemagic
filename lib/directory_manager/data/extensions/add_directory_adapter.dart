import '../../domain/input/add_directory.dart';

extension AddDirectoryInputAdapter on AddDirectoryInput {
  Map<String, dynamic> toJson() {
    return {'path': path};
  }
}
