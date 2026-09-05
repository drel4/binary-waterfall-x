from . import enums

DEFAULTS = {
    "num_channels": 1,
    "sample_bytes": 1,
    "sample_rate": 32000,
    "file_volume": 100,
    "width": 48,
    "height": 48,
    "color_format_string": "bgrx",
    "alignment": enums.AlignmentCode.MIDDLE,
    "playhead_visible": True,
    "flip_v": True,
    "flip_h": False,
    "max_dim": 512,
    "player_fps": 120,
    # Make bwv_encode output work out of the box while preserving legacy
    # QMediaPlayer timing for every other file type.
    "timing_mode": enums.TimingModeCode.BWV_ONLY,
    "bwv_quick_settings": True,
    "bwv_width": 48,
    "bwv_height": 48,
    "bwv_fps": 25,
    "bwv_sample_rate": 32000,
    "bwv_color_mode": enums.ColorModeCode.GRAYSCALE
}
