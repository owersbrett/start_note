import 'package:notime/data/repositories/_repository.dart';

abstract class INoteRepository<Note> extends Repository<Note> {}

class NoteRepository<Note> implements INoteRepository<Note> {
  NoteRepository();
  @override
  Future<Note> create(Note t) async {
    return t;
  }

  @override
  Future<bool> delete(Note t)async  {
    return false;
  }

  @override
  Future<Note> getById(int id)async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Note t) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
