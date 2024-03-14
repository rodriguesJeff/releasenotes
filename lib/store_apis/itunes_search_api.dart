import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ITunesSearchAPI {
  static const String kITunesDocumentationURL =
      'https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/';

  static const String kLookupPrefixURL = 'https://itunes.apple.com/lookup';

  static const String kSearchPrefixURL = 'https://itunes.apple.com/search';

  final client = http.Client();

  bool debugEnabled = false;

  Future<Map<dynamic, dynamic>?> lookupByBundleId(
    String bundleId, {
    required String country,
    required String locale,
    bool useCacheBuster = true,
  }) async {
    assert(bundleId.isNotEmpty);
    if (bundleId.isEmpty) return null;

    final url = lookupURLByBundleId(
          bundleId,
          country: country,
          locale: locale,
          useCacheBuster: useCacheBuster,
        ) ??
        "";
    if (debugEnabled) debugPrint(url);

    try {
      final response = await client.get(Uri.parse(url));
      if (debugEnabled) debugPrint('${response.statusCode}');

      final decodedResults = _decodeResults(response.body);
      return decodedResults;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  Future<Map<dynamic, dynamic>?> lookupById(
    String id, {
    required String country,
    required String locale,
    bool useCacheBuster = true,
  }) async {
    if (id.isEmpty) return null;

    final url = lookupURLById(
      id,
      country: country,
      locale: locale,
      useCacheBuster: useCacheBuster,
    );
    if (debugEnabled) debugPrint(url);

    try {
      final response = await client.get(Uri.parse(url ?? ""));
      final decodedResults = _decodeResults(response.body);
      return decodedResults;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  String? lookupURLByBundleId(
    String bundleId, {
    required String country,
    required String locale,
    bool useCacheBuster = true,
  }) {
    if (bundleId.isEmpty) return null;

    final queryParams = <String, String>{
      'bundleId': bundleId,
      'country': country.toUpperCase(),
      'lang': locale.toLowerCase(),
    };

    return lookupURLByQSP(queryParams, useCacheBuster: useCacheBuster);
  }

  String? lookupURLById(
    String id, {
    required String country,
    required String locale,
    bool useCacheBuster = true,
  }) {
    if (id.isEmpty) return null;

    final queryParams = <String, String>{
      'id': id,
      'country': country.toUpperCase(),
      'lang': locale.toLowerCase(),
    };

    return lookupURLByQSP(queryParams, useCacheBuster: useCacheBuster);
  }

  /// Look up URL by QSP.
  String? lookupURLByQSP(
    Map<String, String?> qsp, {
    bool useCacheBuster = true,
  }) {
    if (qsp.isEmpty) return null;

    final parameters = <String>[];
    qsp.forEach((key, value) => parameters.add('$key=$value'));
    if (useCacheBuster) {
      parameters.add('_cb=${DateTime.now().microsecondsSinceEpoch.toString()}');
    }
    final finalParameters = parameters.join('&');

    return '$kLookupPrefixURL?$finalParameters';
  }

  Map<dynamic, dynamic>? _decodeResults(String jsonResponse) {
    if (jsonResponse.isEmpty) return null;

    final decodedResults = json.decode(jsonResponse);
    if (decodedResults is! Map) return null;
    final resultCount = int.tryParse(decodedResults['resultCount'] ?? "") ?? 0;
    if (resultCount == 0) {
      if (debugEnabled) {
        debugPrint('$decodedResults');
      }
    }
    return decodedResults;
  }
}

class ITunesResults {
  static String? description(Map<dynamic, dynamic> response) {
    String? value;
    try {
      value = response['results'][0]['description'] as String?;
    } catch (e) {
      debugPrint('$e');
    }
    return value;
  }

  static String? releaseNotes(Map<dynamic, dynamic> response) {
    String? value;
    try {
      value = response['results'][0]['releaseNotes'] as String?;
    } catch (e) {
      debugPrint('$e');
    }
    return value;
  }
}
