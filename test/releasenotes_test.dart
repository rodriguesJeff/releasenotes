import 'package:flutter_test/flutter_test.dart';
import 'package:releasenotes/models/release_notes_model.dart';
import 'package:releasenotes/releasenotes.dart';

void main() {
  late ReleaseNotes releaseNotes;

  setUp(() {
    releaseNotes = ReleaseNotes(
      currentVersion: "0.0.1",
      appBundleId: "com.startcom.camporiImortais",
    );
  });

  test(
    "Should return an ReleaseNotesModel with the app version and notes",
    () async {
      final ReleaseNotesModel? notes = await releaseNotes.getReleaseNotes("pt", "BR", locale: "pt_BR");
      expect(notes, isA<ReleaseNotesModel>());
      expect(notes?.version, isA<String?>());
      expect(notes?.notes, isA<String?>());
    },
  );
}
