import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class DatabaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentsDirectory implements Exception {}

//sqLite
/*class NotesService {
  Database? _db;
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}*/

@immutable
class DatabaseUser {
  final int userID;
  final String userEmail;
  const DatabaseUser({
    required this.userID,
    required this.userEmail,
  });
  DatabaseUser.fromRow(Map<String, Object?> map)
      : userID = map[userIdColumn] as int,
        userEmail = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $userID, email = $userEmail';

  @override
  bool operator ==(covariant DatabaseUser other) => userID == other.userID;

  @override
  int get hashCode => userID.hashCode;
}

class DatabaseNote {
  final int noteID;
  final int userID;
  final String noteText;
  final bool isSyncedWithCloud;
  const DatabaseNote({
    required this.noteID,
    required this.userID,
    required this.noteText,
    required this.isSyncedWithCloud,
  });
  DatabaseNote.fromRow(Map<String, Object?> map)
      : noteID = map[noteIdColumn] as int,
        userID = map[userIdColumn] as int,
        noteText = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;
  @override
  String toString() =>
      'NoteID = $noteID, UserID = $userID, IsSyncedWithCloud = $isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => noteID == other.noteID;

  @override
  int get hashCode => noteID.hashCode;
}

const dbName = 'dbneuroukey.db';
const noteTable = 'tblnote';
const userTable = 'tbluser';
const userIdColumn = 'user_id';
const emailColumn = 'user_email';
const noteIdColumn = 'note_id';
const textColumn = 'note_text';
const isSyncedWithCloudColumn = 'is_cloud_synced';
