# J.A.R.V.I.S. Android (Flutter)

Voice-driven JARVIS-inspired Android assistant built in Dart using Flutter, speech recognition, text-to-speech, Android intents and Google's generative AI SDK.

**[Watch the Instagram demo](https://www.instagram.com/p/DIRpe-xTabF/)** · [Screenshots](Images/) · [Releases](https://github.com/Aryan-0001/Jarvis-AI/releases)

> **Maintenance notice:** The published APK is under maintenance. This folder contains a standalone Dart implementation (`jarvis.dart`), not a complete ready-to-run Flutter application at this directory level. You will need a Flutter scaffold and matching dependencies/assets. Features have not been verified against current Android/Flutter versions.

## Use your own Gemini API key — exact code location

1. Create a personal API key at [Google AI Studio](https://aistudio.google.com/app/apikey).
2. Open **`JarvisAppFlutter/jarvis.dart`**.
3. Find class **`_JarvisScreenState`** and this line:

   ```dart
   final String apiKey = "get your api";
   ```

4. For a **local, uncommitted personal copy**, replace the placeholder string with your own key. **Do not commit, screenshot, or upload the key.**
5. In the same class's `initState()`, find:

   ```dart
   model = GenerativeModel(model: 'put-exact-model-name-here', apiKey: apiKey);
   ```

   Replace `put-exact-model-name-here` with a Gemini model ID currently available to your account and compatible with the package version. The placeholder is **not a valid model name**.
6. Save, then build and run the project after setting up the Flutter scaffold below.

### Safer local alternative

Instead of editing the tracked source with your real key, you can modify your **local copy only** to read a compile-time value:

```dart
const String apiKey = String.fromEnvironment('GEMINI_API_KEY');
```

Then supply it when running Flutter:

```sh
flutter run --dart-define=GEMINI_API_KEY=YOUR_LOCAL_KEY
```

This prevents committing the literal key in the Dart source, **but does not keep the key secret inside the compiled APK**. Avoid committing shell history or logs containing the key; for distributed apps use a backend that keeps the key server-side.

## Preparing a Flutter project

1. Install [Flutter](https://docs.flutter.dev/get-started/install), Android tooling and an Android emulator/device. Verify with `flutter doctor`.
2. Create a new Flutter application **outside this repository**, for example `flutter create jarvis_local`.
3. Copy `jarvis.dart` into that project's `lib/main.dart`.
4. Add compatible dependencies to your `pubspec.yaml` for imports used in the file: `google_generative_ai`, `speech_to_text`, `flutter_tts`, `url_launcher`, `android_intent_plus`, `intl`, and `audioplayers`. Use versions compatible with your Flutter SDK; this repository does not currently pin versions for the standalone source.
5. Review Android manifest permissions (including microphone and internet) and package configuration. The source references audio assets such as `sounds/startup.mp3`; supply and register required assets in `pubspec.yaml` or adapt the code.
6. Run `flutter pub get` and `flutter run` from the **new Flutter project directory**, not from this folder.

**This is a source integration guide, not a guarantee of a successful build.** Android API levels, package APIs and speech/background behavior may need additional work.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Gemini API errors | API key, API access, quota, model ID and SDK compatibility |
| `pubspec.yaml` missing | You are in the standalone source directory; create a Flutter project first |
| Package import errors | Add the required packages and verify their versions |
| Microphone doesn't work | Runtime microphone permission, Android manifest, device speech services |
| Missing startup sound | Register or replace referenced audio assets |
| APK works differently from source | Published APK may be outdated; it is under maintenance |

## Security

Never open a pull request containing an API key. If a key was ever published, revoke/rotate it at the provider; deleting it from the latest commit is insufficient because Git history can retain it. Client-side keys are extractable. Restrict quotas and API access for personal experimentation.
