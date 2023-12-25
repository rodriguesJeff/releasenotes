class ReleaseNotesModel {
  final String? notes;
  final String? version;
  final bool isLatestVersion;

  const ReleaseNotesModel({
    this.notes,
    this.version,
    this.isLatestVersion = false,
  });
}
