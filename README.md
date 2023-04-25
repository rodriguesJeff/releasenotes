## Presentation
The package was built using ideas taken from the [upgrader](https://pub.dev/packages/upgrader) and [flutter_app_version_checker](https://pub.dev/packages/flutter_app_version_checker)
Putting the two together I created a form that returns only what is needed for specific situations, the release notes.

## Features

This packages return to you the release notes from next store version of your app.
It don't return an native dialog or something like it, the app purpose is only return the version release notes, with this info you can personalize 
your call to update the way you want with the UI of your preference.

## Getting started

Import the package with the following command:  `flutter pub add releasenotes`

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
final String? notes = await releaseNotes.getReleaseNotes("pt", "BR");
````

The value can be null cause if the app is up to date you don't show the page, modal or some other widget that your preference.

After that you can configure how you prefer what will happen with the information you have received.

## Additional information

Feel free to contribute, open an issue or give your opinion on the usability of the package, to find me, contact me on my [Linkedin](https://www.linkedin.com/in/rodriguesjeffdev/) or email: rodriguesjeff.dev@gmail.com
