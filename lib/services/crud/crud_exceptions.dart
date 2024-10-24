class DatabaseAlreadyOpenException implements Exception {
  @override
  String toString() => "Database is already open";
}

class UnableToGetDocumentsDirectory implements Exception {
  @override
  String toString() => "Unable to get documents directory";
}

class DatabaseIsNotOpen implements Exception {
  @override
  String toString() => "Database is not open";
}

class CouldNotDeleteUser implements Exception {
  @override
  String toString() => "Could not delete user";
}

class UserAlreadyExists implements Exception {
  @override
  String toString() => "User already exists";
}

class CouldNotFindUser implements Exception {
  @override
  String toString() => "Could not find user";
}

class CouldNotDeleteNote implements Exception {
  @override
  String toString() => "Could not delete note";
}

class CouldNotFindNote implements Exception {
  @override
  String toString() => "Could not find note";
}

class CouldNotUpdateNote implements Exception {
  @override
  String toString() => "Could not update note";
}

class UserShouldBeSetBeforeReadingAllNotes implements Exception {
  @override
  String toString() => "User should be set before reading all notes";
}
