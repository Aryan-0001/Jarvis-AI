# J.A.R.V.I.S. for Windows (Python)

A voice-controlled Windows desktop assistant built with Python. Features in the source include spoken responses, web searches, jokes, local application actions, battery information, reminders, and optional media playback.

> **Experimental:** This program uses microphone input and desktop automation, and includes a spoken **shutdown** command that can power off your PC. Read `Jarvis.py` before running it. Some features depend on local files and third-party applications. No Windows end-to-end test has been performed for this update.

## Requirements

- Windows with Python 3 and microphone access
- Working speakers / text-to-speech engine
- Python packages in [requirements.txt](requirements.txt)
- PyAudio and compatible system audio drivers (installation can require extra setup on some Python versions)

## Install

From the repository root in PowerShell:

```powershell
cd JarvisWindows
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python Jarvis.py
```

If PowerShell blocks activation, run `.venv\Scripts\python.exe -m pip install -r requirements.txt` and `.venv\Scripts\python.exe Jarvis.py` directly instead.

## What to expect

- SpeechRecognition uses Google's speech recognition service for some commands; a network connection may be required.
- The `chatgpt` command opens [chatgpt.com](https://chatgpt.com/) in a browser; this is **not** an integrated ChatGPT API.
- WhatsApp and desktop controls rely on local application state and may require manual adjustment.
- Local audio/video assets in this folder may be required for media features.
- Do not run untrusted voice commands around other people: the assistant can trigger desktop actions.

## Troubleshooting

- **Microphone errors:** Check Windows microphone permissions, input device, PyAudio installation and drivers.
- **Missing module:** Install dependencies inside the active virtual environment.
- **No speech output:** Check the Windows voice engine and default playback device.
- **GUI or media failure:** Confirm desktop session, installed applications and local asset paths.

[Back to repository overview](../README.md) · [Watch the JARVIS reel](https://www.instagram.com/p/DIRpe-xTabF/)
