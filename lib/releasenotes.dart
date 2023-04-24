library releasenotes;

import 'dart:io';

import 'package:releasenotes/itunes_search_api.dart';
import 'package:releasenotes/play_store_search_api.dart';
import 'package:releasenotes/update_checker.dart';
import 'package:releasenotes/update_checker_result.dart';

class ReleaseNotes {
  final String currentVersion;
  final String appBundleId;

  ReleaseNotes({
    required this.currentVersion,
    required this.appBundleId,
  });

  Future<String> getReleaseNotes(String lang, String country) async {
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
    if (currentVersion != updateCheckerResult.newVersion &&
        !Platform.isAndroid) {
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
        country: "BR",
      );
      result = ITunesResults.releaseNotes(storeInfos!);
    }
    if (result != null) {
      return result;
    } else {
      return "Problem with version update checker";
    }
  }
}
