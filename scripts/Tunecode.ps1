# =========================================
# Gravity Falls Theme - Terminal Edition
# =========================================

# Load frequencies
. .\pitches.ps1

# -----------------------------
# Melody
# -----------------------------

$melody = @(

    $NOTE_F4, $NOTE_C4, $NOTE_A3, $NOTE_C4, $NOTE_A3, $NOTE_F4,
    $NOTE_F4, $NOTE_C4, $NOTE_A3, $NOTE_C4, $NOTE_A3, $NOTE_F4,

    $NOTE_E4, $NOTE_C4, $NOTE_G3, $NOTE_C4, $NOTE_G3, $NOTE_E4,
    $NOTE_E4, $NOTE_C4, $NOTE_G3, $NOTE_C4, $NOTE_G3, $NOTE_E4,

    $NOTE_E4, $NOTE_CS4, $NOTE_A3, $NOTE_CS4, $NOTE_A3, $NOTE_E4,
    $NOTE_E4, $NOTE_CS4, $NOTE_A3, $NOTE_CS4, $NOTE_A3, $NOTE_E4,

    $NOTE_D4, $NOTE_E4, $NOTE_F4, $NOTE_A4, $NOTE_G4, $NOTE_A4, $NOTE_C4,
    $NOTE_D4, $NOTE_E4, $NOTE_F4, $NOTE_E4, $NOTE_G4, $NOTE_A4, $NOTE_G4, $NOTE_F4,

    $NOTE_F4, $NOTE_F4, $NOTE_F4, $NOTE_A4, $NOTE_A4, $NOTE_G4, $NOTE_F4,
    $NOTE_A4, $NOTE_A4, $NOTE_A4, $NOTE_G4, $NOTE_A4, $NOTE_G4, $NOTE_F4,
    $NOTE_F4, $NOTE_F4, $NOTE_F4, $NOTE_A4, $NOTE_A4, $NOTE_G4, $NOTE_F4,

    $NOTE_A4, $NOTE_A4, $NOTE_A4, $NOTE_CS5, $NOTE_CS5, $NOTE_CS5,
    $NOTE_F4, $NOTE_F4, $NOTE_F4, $NOTE_A4,  $NOTE_A4,  $NOTE_G4, $NOTE_F4

)

# -----------------------------
# Durations
# (must match melody count: 83 notes)
# -----------------------------

$noteDurations = @(

    8,8,8,8,8,8,       # bar 1  (6)
    8,8,8,8,8,8,       # bar 2  (6)

    8,8,8,8,8,8,       # bar 3  (6)
    8,8,8,8,8,8,       # bar 4  (6)

    8,8,8,8,8,8,       # bar 5  (6)
    8,8,8,8,8,8,       # bar 6  (6)

    2,3,3,4,4,2,2,     # bar 7  (7)
    2,3,3,4,4,2,2,2,   # bar 8  (8)

    8,8,8,8,8,8,8,     # bar 9  (7)
    8,8,8,8,8,8,8,     # bar 10 (7)
    8,8,8,8,8,8,8,     # bar 11 (7)

    3,3,3,3,3,2,       # bar 12 (6)
    3,3,3,3,3,3,3      # bar 13 (7)
    # Total = 83 notes

)

# -----------------------------
# ASCII Frames
# Fix: all frames must be the SAME width and height.
# We normalise them in code below so you can write them freely here.
# -----------------------------

$rawFrames = @(

    # 0 - Dipper hat
    @"
  /\_____/\
 /  o   o  \
( ==  ^  == )
 )         (
(           )
 \  |   |  /
  \_|___|_/
"@,

    # 1 - Mabel sparkle
    @"
 *  /\_/\  *
  ( ^   ^ )
  =( Y )=
   )   (
  (_)-(_)
 * Mabel! *
"@,

    # 2 - Grunkle Stan
    @"
  _  ___  _
 ||| |_| |||
 |_| | | |_|
  |  fez |
  | o   o |
  |  ---  |
  |_______|
"@,

    # 3 - Soos
    @"
    _____
   /     \
  | o   o |
  |   w   |
   \_____/
  /|___|\ 
 / |   | \
"@,

    # 4 - Bill Cipher (triangle)
    @"
    /\
   /  \
  / () \
 / /||\ \
/___||___\
    ||
"@,

    # 5 - Shooting star (Mabel shooting star sweater)
    @"
  *       *
    *   *
  * (o.o) *
    *\_/*
  *  | |  *
     | |
"@,

    # 6 - Pine tree (Dipper's hat symbol)
    @"
     /\
    /  \
   / /\ \
  / /  \ \
 / /    \ \
/___/\____\
    ||
    ||
"@,

    # 7 - Mystery Shack sign
    @"
 ___________
|  MYSTERY  |
|   SHACK   |
|___________|
|  OPEN!?   |
|___________|
    ||||
"@,

    # 8 - Ghost
    @"
   .-.-.
  ( o o )
  |  ^  |
  | '-' |
  |     |
 /|     |\
  '-----'
"@,

    # 9 - Waddles (the pig)
    @"
   (\(\ 
   ( -.-)  oink
   o_(")(")
  /  pig  \
 | waddles |
  \_______/
"@,

    # 10 - Gnomes
    @"
   /\/\/\
  ( o  o )
  ( ---- )
   \ /\ /
    V  V
  [gnome!]
"@,

    # 11 - Eye of Providence (Bill's symbol)
    @"
  .-------.
 / ( ) ( ) \
| (  EYE  ) |
|  \ ~~~ /  |
 \   ---   /
  '-.___.--'
"@

)

# -----------------------------
# Normalise all frames to the
# same width & height so that
# each render FULLY overwrites
# the previous one (no ghosting)
# -----------------------------

function Get-NormalisedFrames {
    param([string[]]$frames)

    # Helper: split a here-string, strip \r (CRLF), drop leading+trailing blank lines
    function Clean-Lines([string]$s) {
        $ls = ($s -split "`n") | ForEach-Object { $_ -replace "`r","" }
        while ($ls.Count -gt 0 -and $ls[0].Trim()  -eq "") { $ls = $ls[1..($ls.Count-1)] }
        while ($ls.Count -gt 0 -and $ls[-1].Trim() -eq "") { $ls = $ls[0..($ls.Count-2)] }
        return $ls
    }

    # Measure max width and max height across all frames
    $maxW = 0
    $maxH = 0
    foreach ($f in $frames) {
        $lines = Clean-Lines $f
        if ($lines.Count -gt $maxH) { $maxH = $lines.Count }
        foreach ($l in $lines) { if ($l.Length -gt $maxW) { $maxW = $l.Length } }
    }

    # Pad every frame to exactly ($maxH) lines of ($maxW) chars
    $normalised = @()
    foreach ($f in $frames) {
        $lines  = Clean-Lines $f
        $padded = @()
        foreach ($l in $lines) { $padded += $l.PadRight($maxW) }
        while ($padded.Count -lt $maxH) { $padded += " " * $maxW }
        $normalised += ,($padded)
    }
    return $normalised, $maxH
}

$normResult   = Get-NormalisedFrames -frames $rawFrames
$frames       = $normResult[0]   # array of (array of padded strings)
$frameHeight  = $normResult[1]   # how many lines each frame occupies

# -----------------------------
# Setup
# -----------------------------

$lengthOfMelody = $melody.Length

# Sanity check durations array length
if ($noteDurations.Count -ne $lengthOfMelody) {
    Write-Warning "Duration count ($($noteDurations.Count)) != melody count ($lengthOfMelody). Padding with 8."
    while ($noteDurations.Count -lt $lengthOfMelody) { $noteDurations += 8 }
}

Clear-Host
[Console]::CursorVisible = $false

# Pre-fill screen so later SetCursorPosition(0,0) never scrolls
$headerLines = 5          # header block
$spacerLines = 2          # gaps
$infoLines   = 4          # "Playing / Freq / Dur" block + blank
$progressLines = 1
$totalLines  = $headerLines + $frameHeight + $spacerLines + $infoLines + $progressLines

for ($x = 0; $x -lt $totalLines; $x++) { Write-Host "" }

# Colour helpers — use [char]27 (ESC) for PS5 compatibility
# `e[...m only works in PS7+; [char]27 works in PS5 and PS7 both
$ESC     = [char]27
$cyan    = "$ESC[96m"
$yellow  = "$ESC[93m"
$magenta = "$ESC[95m"
$green   = "$ESC[92m"
$reset   = "$ESC[0m"

# -----------------------------
# Main Loop
# -----------------------------

for ($i = 0; $i -lt $lengthOfMelody; $i++) {

    [Console]::SetCursorPosition(0, 0)

    $freq    = $melody[$i]
    $durBase = $noteDurations[$i]

    if ($null -eq $freq   -or $null -eq $durBase) { continue }
    if ($freq -lt 37 -or $freq -gt 32767)          { continue }

    $noteDuration = [int]((1000 / $durBase) * 2)
    if ($noteDuration -lt 80) { $noteDuration = 80 }

    # Pick frame (cycle through all 12)
    $frameLines = $frames[$i % $frames.Count]

    # ---- Header ----
    Write-Host "${cyan}======================================${reset}"
    Write-Host "${yellow}     Gravity Falls Terminal Player    ${reset}"
    Write-Host "${cyan}======================================${reset}"
    Write-Host ""

    # ---- ASCII art (pre-padded, so no ghosting) ----
    foreach ($line in $frameLines) {
        Write-Host "${magenta}${line}${reset}"
    }

    Write-Host ""

    # ---- Info ----
    Write-Host "${green}  Playing note $($i+1) of $lengthOfMelody${reset}"
    Write-Host "  Frequency : ${yellow}${freq} Hz${reset}"
    Write-Host "  Duration  : ${yellow}${noteDuration} ms${reset}"
    Write-Host ""

    # ---- Progress bar ----
    $percent  = ($i + 1) / $lengthOfMelody
    $barLen   = 38
    $filled   = [int]($percent * $barLen)
    $bar      = ("#" * $filled).PadRight($barLen, "-")
    $pct      = [int]($percent * 100)
    Write-Host "  [${green}${bar}${reset}] ${pct}%  "

    # ---- Play ----
    [console]::Beep([int]$freq, [int]$noteDuration)
}

# -----------------------------
# Finish
# -----------------------------

[Console]::SetCursorPosition(0, 0)

# Print a final full-screen clear so no partial frame lingers
for ($x = 0; $x -lt $totalLines; $x++) {
    Write-Host (" " * 50)
}

[Console]::SetCursorPosition(0, 0)

Write-Host ""
Write-Host "${cyan}======================================${reset}"
Write-Host "${yellow}           DONE  ~  Thanks!           ${reset}"
Write-Host "${cyan}======================================${reset}"
Write-Host ""
Write-Host "  Mystery solved.  (?/?)"
Write-Host ""

[Console]::CursorVisible = $true