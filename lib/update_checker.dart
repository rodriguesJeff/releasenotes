import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:releasenotes/update_checker_result.dart';

class UpdateChecker {
  Future<UpdateCheckerResult> checkIfAppHasUpdates({
    required String currentVersion,
    required String appBundleId,
    required bool isAndroid,
  }) async {
    final currentVersion0 = currentVersion;
    final packageName = appBundleId;
    if (isAndroid) {
      return await _checkUpdatesOnPlayStore(currentVersion0, packageName);
    } else {
      return await _checkUpdatesInAppStore(currentVersion0, packageName);
    }
  }

  Future<UpdateCheckerResult> _checkUpdatesInAppStore(
      String currentVersion, String packageName) async {
    String? errorMsg;
    String? newVersion;
    String? url;
    var uri =
        Uri.https("itunes.apple.com", "/lookup", {"bundleId": packageName});
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        errorMsg =
            "Can't find an app in the Apple Store with the id: $packageName";
      } else {
        final jsonObj = jsonDecode(response.body);
        final List results = jsonObj['results'];
        if (results.isEmpty) {
          errorMsg =
              "Can't find an app in the Apple Store with the id: $packageName";
        } else {
          newVersion = jsonObj['results'][0]['version'];
          url = jsonObj['results'][0]['trackViewUrl'];
        }
      }
    } catch (e) {
      errorMsg = "$e";
    }
    return UpdateCheckerResult(
      currentVersion,
      newVersion,
      url,
      errorMsg,
    );
  }

  Future<UpdateCheckerResult> _checkUpdatesOnPlayStore(
      String currentVersion, String packageName) async {
    String? errorMsg;
    String? newVersion;
    String? url;
    final uri = Uri.https(
      "play.google.com",
      "/store/apps/details",
      {"id": packageName, "gl": "BR", "hl": "pt", "_cb": ""},
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        errorMsg =
            "Can't find an app in the Google Play Store with the id: $packageName";
      } else {
        newVersion = RegExp(r',\[\[\["([0-9,\.]*)"]],')
            .firstMatch(response.body)!
            .group(1);
        url = uri.toString();
      }
    } catch (e) {
      errorMsg = "$e";
    }
    return UpdateCheckerResult(
      currentVersion,
      newVersion,
      url,
      errorMsg,
    );
  }
}
