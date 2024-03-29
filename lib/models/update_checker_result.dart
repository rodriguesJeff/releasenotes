import 'dart:math' as math;

class UpdateCheckerResult {
  final String currentVersion;
  final String? newVersion;
  final String? appURL;
  final String? errorMessage;

  UpdateCheckerResult(
    this.currentVersion,
    this.newVersion,
    this.appURL,
    this.errorMessage,
  );

  bool get canUpdate => shouldUpdate;

  @override
  String toString() {
    return "Current Version: $currentVersion\nNew Version: $newVersion\nApp URL: $appURL\ncan update: $canUpdate\nerror: $errorMessage";
  }
}

extension on UpdateCheckerResult {
  bool get shouldUpdate {
    final versionA = currentVersion;
    final versionB = newVersion ?? currentVersion;

    final versionNumbersA =
        versionA.split(".").map((e) => int.tryParse(e) ?? 0).toList();
    final versionNumbersB =
        versionB.split(".").map((e) => int.tryParse(e) ?? 0).toList();

    final int versionASize = versionNumbersA.length;
    final int versionBSize = versionNumbersB.length;
    final maxSize = math.max(versionASize, versionBSize);

    for (int i = 0; i < maxSize; i++) {
      final firstComparableValue = i < versionASize ? versionNumbersA[i] : 0;
      final secondComparableValue = i < versionBSize ? versionNumbersB[i] : 0;

      if (firstComparableValue > secondComparableValue) return false;
      if (firstComparableValue < secondComparableValue) return true;
    }
    return false;
  }
}
