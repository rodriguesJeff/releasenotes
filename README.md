## Presentation
The package was built using ideas taken from the [upgrader](https://pub.dev/packages/upgrader) and [flutter_app_version_checker](https://pub.dev/packages/flutter_app_version_checker)
Putting the two together I created a form that returns only what is needed for specific situations, the Release Notes.

## Features

This packages return to you the release notes from next store version of your app.
It don't return an native dialog or something like it, the app purpose is only return the version release notes, with this info you can personalize 
your call to update the way you want with the UI of your preference.

## Getting started

Import the package with the following command:  
`
flutter pub add releasenotes
`

# Note
For this example i'm using an app developed by me that is in Google Play Stoore

## Usage
For use the package, you need to init the instance:

```dart
final releaseNotes = ReleaseNotes(
  appBundleId:  "com.startcom.camporiImortais",
  currentVersion: "0.0.1",
);
```
After that, you only need to call the `getReleaseNotes` function passing language and country as parameter:

````dart
Future<ReleaseNotesModel?> getReleaseNotes() async {
  return await releaseNotes.getReleaseNotes(
    "pt",
    "BR",
    locale: "pt_BR", // For iOS, this property is must have to get release notes localized
  );
}
````

If current version == store version => the property isLatest = true. It indicates that the current version of the app is matched with the version on the store.
The value be null once error.

After that you can configure how you prefer what will happen with the information you have received.

Want to see an example? Please go to our [sample app](https://github.com/rodriguesJeff/releasenotes/blob/main/example/lib/main.dart)

## Additional information

Feel free to contribute, open an issue or give your opinion on the usability of the package, to find me, contact me on my [Linkedin](https://www.linkedin.com/in/rodriguesjeffdev/) or email: rodriguesjeff.dev@gmail.com

Made with <3 for [@rodriguesjeff.dev](https://rodriguesjeff.dev)