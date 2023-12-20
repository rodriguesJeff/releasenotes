library releasenotes;

import 'dart:io';

import 'package:releasenotes/itunes_search_api.dart';
import 'package:releasenotes/models/release_notes_model.dart';
import 'package:releasenotes/play_store_search_api.dart';
import 'package:releasenotes/update_checker.dart';
import 'package:releasenotes/update_checker_result.dart';

class ReleaseNotes {
  final String currentVersion;
  final String appBundleId;

  ReleaseNotes({
    required this.currentVersion,
    required this.appBundleId,
  })  : assert(currentVersion.isNotEmpty),
        assert(appBundleId.isNotEmpty);

  Future<ReleaseNotesModel?> getReleaseNotes(
    String lang,
    String country, {
    String? locale,
  }) async {
    assert(lang.isNotEmpty && lang.trim().length == 2);
    assert(country.isNotEmpty && country.trim().length == 2);
    if (Platform.isIOS) {
      assert(locale != null && locale.isNotEmpty && locale.length == 5);
    }

    final playStoreSearch = PlayStoreSearchAPI();
    final itunesSoreSearch = ITunesSearchAPI();
    String? result;

    // Get the last version of the store
    final UpdateCheckerResult updateCheckerResult =
        await UpdateChecker().checkIfAppHasUpdates(
      currentVersion: currentVersion,
      appBundleId: appBundleId,
      isAndroid: Platform.isAndroid,
    );

    if (currentVersion == updateCheckerResult.newVersion) return null;

    // Get release notes from the store selected
    if (Platform.isAndroid) {
      final storeInfos = await playStoreSearch.lookupById(
        appBundleId,
        language: lang,
        country: country,
      );
      result = PlayStoreResults.releaseNotes(storeInfos!);
    } else {
      final Map<dynamic, dynamic>? storeInfos =
          await itunesSoreSearch.lookupByBundleId(
        appBundleId,
        country: country,
        locale: locale!,
      );
      result = ITunesResults.releaseNotes(storeInfos!);
    }

    final ReleaseNotesModel releaseNotes = ReleaseNotesModel(
      notes: result,
      version: updateCheckerResult.newVersion,
    );

    return releaseNotes;
  }
}
