# J.A.R.V.I.S. — Voice Assistant Projects

A collection of experimental JARVIS-inspired assistants for **Android (Flutter/Dart)** and **Windows (Python)**, plus an early **Jarvis Vision** prototype.

[![License](https://img.shields.io/github/license/Aryan-0001/Jarvis-AI)](LICENSE) [![Issues](https://img.shields.io/github/issues/Aryan-0001/Jarvis-AI)](https://github.com/Aryan-0001/Jarvis-AI/issues) [![Releases](https://img.shields.io/github/v/release/Aryan-0001/Jarvis-AI)](https://github.com/Aryan-0001/Jarvis-AI/releases)

**🎬 [Watch JARVIS in action on Instagram](https://www.instagram.com/p/DIRpe-xTabF/)**

> **Android APK status:** Under maintenance. The downloadable release may not work as expected. To use your own Gemini API key, build from source using the Android setup guide below. This is a hobby/experimental project, not a production-ready assistant.

## Choose your version

| Project | Platform | Description | Start here |
| --- | --- | --- | --- |
| [JarvisAppFlutter](JarvisAppFlutter/) | Android | Flutter voice interaction, speech-to-text, text-to-speech, Gemini responses, Android intents | [Android setup](JarvisAppFlutter/README.md) |
| [JarvisWindows](JarvisWindows/) | Windows | Python voice commands and desktop automation | [Windows setup](JarvisWindows/README.md) |
| [jarvis-vision](jarvis-vision/) | Experimental | Early vision/object recognition work | [Vision notes](jarvis-vision/README.md) |

## Android: use your own Gemini API key

The Android source currently lives in **`JarvisAppFlutter/jarvis.dart`**. In class `_JarvisScreenState`, the source contains:

```dart
final String apiKey = "get your api";
```

The model is initialized in `initState()`:

```dart
model = GenerativeModel(model: 'put-exact-model-name-here', apiKey: apiKey);
```

For a **personal local build only**, replace the API placeholder with a key from [Google AI Studio](https://aistudio.google.com/app/apikey) and the model placeholder with an available model supported by your SDK and account. **Never commit or share a real key.** See the [full Android setup and safety notes](JarvisAppFlutter/README.md).

**Important:** An API key embedded in a mobile APK can be extracted. This method is suitable only for personal experimentation with a restricted, quota-limited key; a distributed app should call Gemini through a secure backend instead.

## Project status and limitations

- The Android source is currently a standalone Dart file, **not a complete Flutter project at the repository root**. A Flutter project scaffold, package dependencies, Android permissions, and assets are needed before building.
- The Android APK is marked under maintenance; releases are provided as-is.
- Windows features may depend on local applications, microphone access, and installed Python packages. Review scripts before executing automation commands.
- Jarvis Vision is experimental and should not be assumed complete.
- No automated build or device test results are claimed here.

## Screenshots and releases

- [Android screenshots](JarvisAppFlutter/Images/)
- [GitHub releases](https://github.com/Aryan-0001/Jarvis-AI/releases)
- [Instagram demo reel](https://www.instagram.com/p/DIRpe-xTabF/)

## Contribute

Bug reports, documentation improvements, and focused pull requests are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) before contributing. Please don't post API keys, credentials, or personal information in issues.

## License

See [LICENSE](LICENSE).
