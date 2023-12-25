import 'package:flutter/material.dart';
import 'package:releasenotes/models/release_notes_model.dart';
import 'package:releasenotes/releasenotes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String kBundleId = "vio.app";
  static const String kCurrentVersion = "1.0.3";

  String? notes;
  String? version;
  bool? isLatest;
  bool isLoading = false;

  getReleaseNotes() async {
    setState(() => isLoading = true);
    final releaseNotes = ReleaseNotes(
      appBundleId: kBundleId,
      currentVersion: kCurrentVersion,
    );
    print(releaseNotes.currentVersion);
    final ReleaseNotesModel? releaseNotesModel =
        await releaseNotes.getReleaseNotes("vi", "VN", locale: "vi_VN");
    setState(() {
      notes = releaseNotesModel?.notes ?? "Without notes";
      version = releaseNotesModel?.version ?? "No version find";
      isLatest = releaseNotesModel?.isLatestVersion ?? false;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getReleaseNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ReleaseNotes"),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("current version: $kCurrentVersion"),
                  Text("store release notes: $notes"),
                  Text("store version: $version"),
                  Text("isLatest: $isLatest"),
                ],
              ),
      ),
    );
  }
}
