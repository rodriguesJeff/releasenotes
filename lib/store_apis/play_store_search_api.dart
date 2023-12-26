import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class PlayStoreSearchAPI {
  PlayStoreSearchAPI({http.Client? client}) : client = client ?? http.Client();
  final String playStorePrefixURL = 'play.google.com';
  final http.Client? client;

  bool debugEnabled = false;

  Future<Document?> lookupById(String id,
      {String? country = 'US',
      String? language = 'en',
      bool useCacheBuster = true}) async {
    assert(id.isNotEmpty);
    if (id.isEmpty) return null;

    final url = lookupURLById(id,
        country: country, language: language, useCacheBuster: useCacheBuster)!;
    if (debugEnabled) {
      debugPrint(url);
    }

    try {
      final response = await client!.get(Uri.parse(url));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(id);
        return null;
      }

      final decodedResults = _decodeResults(response.body);

      return decodedResults;
    } on Exception catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  String? lookupURLById(String id,
      {String? country = 'US',
      String? language = 'en',
      bool useCacheBuster = true}) {
    assert(id.isNotEmpty);
    if (id.isEmpty) return null;

    Map<String, dynamic> parameters = {'id': id};
    if (country != null && country.isNotEmpty) {
      parameters['gl'] = country;
    }
    if (language != null && language.isNotEmpty) {
      parameters['hl'] = language;
    }
    if (useCacheBuster) {
      parameters['_cb'] = DateTime.now().microsecondsSinceEpoch.toString();
    }
    final url = Uri.https(playStorePrefixURL, '/store/apps/details', parameters)
        .toString();

    return url;
  }

  Document? _decodeResults(String jsonResponse) {
    if (jsonResponse.isNotEmpty) {
      final decodedResults = parse(jsonResponse);
      return decodedResults;
    }
    return null;
  }
}

class PlayStoreResults {
  static RegExp releaseNotesSpan = RegExp(r'>(.*?)</span>');

  static String? description(Document response) {
    try {
      final sectionElements = response.getElementsByClassName('W4P4ne');
      final descriptionElement = sectionElements[0];
      final description = descriptionElement
          .querySelector('.PHBdkd')
          ?.querySelector('.DWPxHb')
          ?.text;
      return description;
    } catch (e) {
      return redesignedDescription(response);
    }
  }

  static String? redesignedDescription(Document response) {
    try {
      final sectionElements = response.getElementsByClassName('bARER');
      final descriptionElement = sectionElements.last;
      final description = descriptionElement.text;
      return description;
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  static String? releaseNotes(Document response) {
    try {
      final sectionElements = response.getElementsByClassName('W4P4ne');
      final releaseNotesElement = sectionElements.firstWhere(
          (elm) => elm.querySelector('.wSaTQd')!.text == 'What\'s New',
          orElse: () => sectionElements[0]);

      final rawReleaseNotes = releaseNotesElement
          .querySelector('.PHBdkd')
          ?.querySelector('.DWPxHb');
      final releaseNotes = rawReleaseNotes == null
          ? null
          : multilineReleaseNotes(rawReleaseNotes);

      return releaseNotes;
    } catch (e) {
      return redesignedReleaseNotes(response);
    }
  }

  static String? redesignedReleaseNotes(Document response) {
    try {
      final sectionElements =
          response.querySelectorAll('[itemprop="description"]');

      final rawReleaseNotes = sectionElements.last;
      final releaseNotes = multilineReleaseNotes(rawReleaseNotes);
      return releaseNotes;
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  static String? multilineReleaseNotes(Element rawReleaseNotes) {
    final innerHtml = rawReleaseNotes.innerHtml;
    String? releaseNotes = innerHtml;

    if (releaseNotesSpan.hasMatch(innerHtml)) {
      releaseNotes = releaseNotesSpan.firstMatch(innerHtml)!.group(1);
    }
    // Detect default multiline replacement
    releaseNotes = releaseNotes!.replaceAll('<br>', '\n');

    return releaseNotes;
  }
}
