# <img src="src/binary_waterfall/resources/icon.png" height="20px" alt="Binary Waterfall"/> Binary Waterfall
### A Raw Data Media Player

> [!WARNING]
> **This active fork is vibecoded.** AI-assisted development is used openly in this project.
> If you do not like AI-generated or AI-assisted software, please do not use this fork.

This repository is an active fork of [nimaid/binary-waterfall](https://github.com/nimaid/binary-waterfall),
kept under the original **GNU GPL v3** license. It remains a raw-data media player: any file can be
interpreted as audio and video at the same time.

<p align="center"><img src="docs/example.png" width="400px" alt="Running the program on mspaint.exe"/></p>

<p align="center"><a href="https://www.youtube.com/watch?v=NFe0aGO9-TE">Inspired by this video.</a></p>

## Downloads
<table align="center" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse !important;">
    <tr style="border: none !important;">
        <td align="center" style="border: none !important;">
            <a href="https://nimaid.itch.io/binary-waterfall">
                <img src="docs/windows.png" width="150px" alt="Click here to download the program for Windows!"/>
                <br />
                <b>Windows</b>
            </a>
        </td>
        <td align="center" style="border: none !important;">
            <a href="https://pypi.org/project/binary-waterfall/">
                <img src="docs/python.png" width="150px" alt="Click here to download the program for Python!"/>
                <br />
                <b>All Platforms</b>
            </a>
        </td>
    </tr>
</table>

## Attribution
If you use this program to make a video or other project, you must provide attribution. Attribution is required regardless of whether your project is for-profit or not. Please reproduce the following attribution statement in full in your video description or otherwise include it in the references for your project:
```
Made with the help of Binary Waterfall:
https://github.com/nimaid/binary-waterfall
```

## Keyboard Shortcuts
- **Play / Pause:** `Spacebar`
- **Back:** `Left Arrow`
- **Forward:** `Right Arrow`
- **Frame Back:** `<` (`,`)
- **Frame Forward:** `>` (`.`)
- **Restart:** `R`
- **Volume Up:** `Up Arrow`
- **Volume Down:** `Down Arrow`
- **Mute / Unmute:** `M`

## Fork Features

- **Selectable frame timing:** Settings → Player offers a tri-state timing control:
  **Off** follows `QMediaPlayer`, **BWV-only** uses an elapsed clock for `.bwv` files, and
  **On** uses the elapsed clock for every file. The selection is saved between launches.
- **BWV Quick Settings:** optionally prompts when opening `.bwv` output from
  [bwv_encode](https://github.com/randomtypek/bwv_encode). It supports the encoder's grayscale/RGB
  layouts and 25/20/10/5 FPS choices, fixes audio at stereo 32-bit, and asks for the width, height,
  and sample rate printed by the encoder. It also applies Frame End alignment, hides the playhead,
  and enables the encoder's default vertical flip. Toggle the prompt under Settings.
- **Drag and drop:** drop a local file onto the main window to open it.
- **Reliable playback controls:** play/pause tracks intended state and Play restarts files that have
  reached the end.

`.bwv` is a filename-extension convention used by this fork; the raw format has no embedded header.

## External Resources

- [bwv_encode](https://github.com/randomtypek/bwv_encode) — external video encoder that produces raw
  files for Binary Waterfall. It is a separate project maintained by its own authors.
- [Original Binary Waterfall](https://github.com/nimaid/binary-waterfall) — upstream project this fork
  is based on.

## Showcase Video
[<img src="https://i.ytimg.com/vi/gZRWbv_aob0/maxresdefault.jpg" width="300px">](https://www.youtube.com/watch?v=gZRWbv_aob0 "Microsoft Paint Remix")
