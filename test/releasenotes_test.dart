import 'package:flutter_test/flutter_test.dart';
import 'package:releasenotes/releasenotes.dart';

void main() {
  late ReleaseNotes releaseNotes;

  setUp(() {
    releaseNotes = ReleaseNotes(
        currentVersion: "0.0.1", appBundleId: "com.startcom.camporiImortais");
  });

  test(
    "Should return the app release notes",
    () async {
      final notes = await releaseNotes.getReleaseNotes("pt", "BR");
      expect(notes, isA<String>());
    },
  );
}
