<div align="center">

```
 ██████╗ ██████╗  █████╗ ██╗   ██╗██╗████████╗██╗   ██╗    ███████╗ █████╗ ██╗     ██╗     ███████╗
██╔════╝ ██╔══██╗██╔══██╗██║   ██║██║╚══██╔══╝╚██╗ ██╔╝    ██╔════╝██╔══██╗██║     ██║     ██╔════╝
██║  ███╗██████╔╝███████║██║   ██║██║   ██║    ╚████╔╝     █████╗  ███████║██║     ██║     ███████╗
██║   ██║██╔══██╗██╔══██║╚██╗ ██╔╝██║   ██║     ╚██╔╝      ██╔══╝  ██╔══██║██║     ██║     ╚════██║
╚██████╔╝██║  ██║██║  ██║ ╚████╔╝ ██║   ██║      ██║       ██║     ██║  ██║███████╗███████╗███████║
 ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝   ╚═╝      ╚═╝       ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
```

### Terminal Music Player

*A retro command-line audio engine built entirely in PowerShell*

<br>

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Dependencies](https://img.shields.io/badge/Dependencies-None-brightgreen?style=for-the-badge)
![License](https://img.shields.io/badge/License-Open%20Source-orange?style=for-the-badge)

<br>

> Plays the **Gravity Falls theme** note-by-note inside your terminal — with live ASCII art, animated progress bar, and ANSI colours.
> No libraries. No installs. Just PowerShell and a beeper.

<br>

[**Getting Started**](#-getting-started) · [**How It Works**](#-how-it-works) · [**Customisation**](#-customisation) · [**Troubleshooting**](#-troubleshooting)

</div>

---

## 📸 Preview

```
══════════════════════════════════════
      Gravity Falls Terminal Player
══════════════════════════════════════

        /\
       /  \
      / /\ \
     / / o\ \
    /___||___\
        ||
  BILL  ||  CIPHER

  ♪  Playing note 42 of 83
  Frequency :  440 Hz
  Duration  :  125 ms

  [##################--------------------] 51%
```

---

## ✨ Features

| | Feature | Description |
|---|---|---|
| 🎼 | **Melody Playback** | Note-by-note audio via PowerShell's native `[console]::Beep()` engine |
| ⏱️ | **Timing Control** | Per-note duration arrays with floor clamping for smooth, consistent playback |
| 🎨 | **ASCII Visuals** | 12 Gravity Falls themed frames cycling in sync with each note |
| 📊 | **Progress Bar** | Animated real-time indicator that updates every note without screen flicker |
| 🔧 | **Ghost-fix Renderer** | All frames auto-padded to identical dimensions — zero character bleed-through |
| 🌈 | **ANSI Colours** | PS5-compatible colour system built with `[char]27` escape sequences |
| ⚡ | **Zero Dependencies** | Pure PowerShell — no modules, packages, or internet connection required |
| 🧠 | **Educational** | Clean, well-commented code ideal for learning PowerShell scripting |

---

## 📂 Project Structure

```text
gravity-falls-terminal-music/
│
├── scripts/
│   ├── pitches.ps1          ← note frequency definitions (NOTE_A4 = 440, etc.)
│   └── Tunecode.ps1         ← main playback engine — melody, visuals, audio loop
│
└── README.md
```

### File Overview

| File | Purpose |
|---|---|
| `pitches.ps1` | Maps named note variables (e.g. `$NOTE_F4`) to their Hz frequency values |
| `Tunecode.ps1` | Main script — sequences the melody, renders ASCII frames, drives audio and UI |

---

## 🚀 Getting Started

### Requirements

- Windows PowerShell **5.1 or later**
- Windows **10 build 1511+** — required for ANSI colour rendering
- **Windows Terminal** recommended for best results (full Unicode + colour support)
- Speakers or headphones

### Installation

**1. Clone the repository**
```bash
git clone git@github.com:divyanshukdas-cmyk/gravity-falls-terminal-music.git
```

**2. Navigate into the folder**
```powershell
cd gravity-falls-terminal-music
```

**3. Allow script execution**

Run PowerShell **as Administrator** and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Type `Y` when prompted.

**4. Run the player**
```powershell
.\Tunecode.ps1
```

> **Note:** If you see a security prompt about running scripts, ensure you ran step 3 first. You only need to do this once.

---

## 🧠 How It Works

The player is built around three systems that run together inside a single loop:

### 🔊 Audio Engine

Note frequencies are stored as named variables in `pitches.ps1` (e.g. `$NOTE_A4 = 440`). The `$melody` array sequences these notes and the `$noteDurations` array controls how long each one plays. On every iteration, PowerShell calls:

```powershell
[console]::Beep([int]$frequency, [int]$milliseconds)
```

This drives audio through the system's built-in beep driver — no audio libraries, no external tools.

### 🎨 Visual Renderer

Twelve Gravity Falls ASCII frames are defined as PowerShell here-strings. Before playback begins, a `Get-NormalisedFrames` function processes every frame:

1. Splits on `` `n `` and strips `
` (Windows `CRLF` handling)
2. Removes leading and trailing blank lines that here-strings produce
3. Pads every frame to an identical width and height with spaces

This guarantees that each render **fully overwrites** the previous frame with no character ghosting.

### 🖥️ Terminal Loop

Instead of calling `Clear-Host` each note (which causes flicker), the cursor is repositioned to row `0` with:

```powershell
[Console]::SetCursorPosition(0, 0)
```

Content is then rewritten in-place. ANSI colour sequences are built using `[char]27` (the ESC character) rather than the `` `e `` syntax, ensuring compatibility with both **PowerShell 5.1** and **PowerShell 7+**.

---

## 🎛️ Customisation

### Adding your own melody

Open `Tunecode.ps1` and edit the `$melody` array. Each element references a note variable from `pitches.ps1`. Add a matching entry to `$noteDurations` for every note — the script warns you at runtime if the counts don't match and auto-pads to recover.

```powershell
$melody = @(
    $NOTE_A4, $NOTE_G4, $NOTE_F4,
    ...
)

$noteDurations = @(
    8, 8, 4,
    ...
)
```

Duration values follow the **inverse musical convention** — `8` = eighth note (short), `2` = half note (long).

### Replacing ASCII frames

Edit the `$rawFrames` array in `Tunecode.ps1`. Each frame lives inside a `@' '@` here-string block.

> **Rules:**
> - Use `@' '@` (single-quote) not `@" "@`
> - The comma after `'@` is required between frames
> - `'@` must start at the beginning of the line

### Changing colours

Six colour variables sit near the top of `Tunecode.ps1`. Swap ANSI values to customise the visual style.

---

## 🛠️ Troubleshooting

| Problem | Fix |
|---|---|
| Colours show as raw ANSI text | Ensure you're using the latest script version with `[char]27` escape sequences |
| No sound plays | Check system volume and beep driver settings |
| ASCII art ghosting | Ensure all frames use proper here-strings |
| Script execution blocked | Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| Unicode characters broken | Use Windows Terminal instead of legacy conhost |

---

## 🔨 Built With

- **Windows PowerShell 5.1+**
- **`[console]::Beep()`**
- **ANSI escape sequences**
- **PowerShell here-strings**
- **Git + GitHub**

---

## 💡 Why This Exists

Turning PowerShell into a music player sounded absurd at first.

Then it became a real experiment in terminal rendering, audio timing, and frame normalisation.

It's chaotic. It's pointless. It works perfectly.

---

## 📜 License

Open source — free to use, fork, and learn from for personal and educational purposes.

---

## ⭐ Support

If this project was interesting or useful to you, consider **starring the repository** on GitHub.

It genuinely helps a lot. 🚀

---

<div align="center">

*Made with PowerShell, curiosity, and way too many beeps*

**[⭐ Star on GitHub](https://github.com/divyanshukdas-cmyk/powershell-music-player.git)**

</div>

