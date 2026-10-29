<p align="center"><img src="https://visitor-badge.laobi.icu/badge?page_id=Aryan-0001.Jarvis-AI" alt="Repository visitor counter"></p>

# J.A.R.V.I.S. — Voice Assistant Projects

**[Explore the JARVIS website](https://aryan-0001.github.io/Jarvis-AI/)** · **[Watch the original Instagram demo](https://www.instagram.com/p/DIRpe-xTabF/)**

A collection of experimental JARVIS-inspired assistants for **Android (Flutter/Dart)** and **Windows (Python)**, plus an early **Jarvis Vision** prototype.

[![License](https://img.shields.io/github/license/Aryan-0001/Jarvis-AI)](LICENSE) [![Issues](https://img.shields.io/github/issues/Aryan-0001/Jarvis-AI)](https://github.com/Aryan-0001/Jarvis-AI/issues)

**🎬 [Watch JARVIS in action on Instagram](https://www.instagram.com/p/DIRpe-xTabF/)**

> **Android APK status:** Under maintenance. There are currently no GitHub releases or downloadable APKs. To use your own Gemini API key, build from source using the Android setup guide below. This is a hobby/experimental project, not a production-ready assistant.

## New here? Start with these steps

1. **Watch the demo:** [Original Instagram reel](https://www.instagram.com/p/DIRpe-xTabF/).
2. **Choose a platform:** Android source, Windows Python script, or experimental Vision prototype below.
3. **Read the matching setup guide before installing.** The Android APK is under maintenance and the Android source is not a complete Flutter project.
4. **Android users:** Bring your own Gemini API key and model name; never commit a key.
5. **Need help?** Read the [contribution guide](CONTRIBUTING.md) and [open a detailed issue](https://github.com/Aryan-0001/Jarvis-AI/issues/new/choose).

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
- There are currently **no published GitHub releases or downloadable APKs**. Android builds are under maintenance.
- Windows features may depend on local applications, microphone access, and installed Python packages. Review scripts before executing automation commands.
- Jarvis Vision is experimental and should not be assumed complete.
- No automated build or device test results are claimed here.

## Screenshots and demo

- [Android screenshots](JarvisAppFlutter/Images/)
- [Instagram demo reel](https://www.instagram.com/p/DIRpe-xTabF/)

## Contribute

Bug reports, documentation improvements, and focused pull requests are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) before contributing. Please don't post API keys, credentials, or personal information in issues.

## License

See [LICENSE](LICENSE).

---

<p align="center"><img src="https://readme-typing-svg.herokuapp.com?font=cursive&size=30&pause=100&color=00FF00&center=true&vCenter=true&width=750&lines=You+have+reached+the+end+of+this+REPO;Please+leave+behind+a+star+if+u+enjoyed+it+!;Please+feel+free+to+drop+a+suggestion+in+discussion;Thanks+!" alt="You have reached the end of this repo. Please leave a star if you enjoyed it. Feel free to drop a suggestion. Thanks!"></p>

