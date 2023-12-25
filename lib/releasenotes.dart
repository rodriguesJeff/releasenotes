library releasenotes;

import 'dart:io';

import 'package:releasenotes/store_apis/itunes_search_api.dart';
import 'package:releasenotes/models/release_notes_model.dart';
import 'package:releasenotes/store_apis/play_store_search_api.dart';
import 'package:releasenotes/helpers/update_checker.dart';
import 'package:releasenotes/models/update_checker_result.dart';

class ReleaseNotes {
  final String currentVersion;
  final String appBundleId;

  ReleaseNotes({
    required this.currentVersion,
    required this.appBundleId,
  })  : assert(currentVersion.isNotEmpty),
        assert(appBundleId.isNotEmpty),
        assert(currentVersion.contains(".")),
        assert(appBundleId.contains("."));

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

    try {
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
        isLatestVersion: !updateCheckerResult.canUpdate,
      );

      return releaseNotes;
    } catch (e) {
      rethrow;
    }
  }
}
