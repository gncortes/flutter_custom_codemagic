import '../../domain/entities/directory_entity.dart';
import '../models/directory_model.dart';

extension DirectoryModelAdapter on DirectoryModel {
  DirectoryEntity toEntity() {
    return DirectoryEntity(
      id: id,
      path: path,
      createdAt: DateTime.parse(createdAt).toLocal(),
      updatedAt: DateTime.parse(updatedAt).toLocal(),
    );
  }
}
