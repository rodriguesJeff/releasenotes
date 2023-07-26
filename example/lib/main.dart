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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final releaseNotes = ReleaseNotes(
    appBundleId: "com.startcom.camporiImortais",
    currentVersion: "0.0.1",
  );

  String? notes;
  String? version;
  bool isLoading = false;

  getReleaseNotes() async {
    setState(() => isLoading = true);
    final ReleaseNotesModel? releaseNotesModel =
        await releaseNotes.getReleaseNotes("pt", "BR");
    setState(() {
      notes = releaseNotesModel?.notes ?? "Without notes";
      version = releaseNotesModel?.version ?? "No version find";
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
                  Text("$notes"),
                  Text("$version"),
                ],
              ),
      ),
    );
  }
}
