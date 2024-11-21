import '../../domain/input/update_directory.dart';

extension UpdateDirectoryInputAdapter on UpdateDirectoryInput {
  Map<String, dynamic> toJson() {
    return {'path': path};
  }
}
