from PyQt5.QtCore import QSettings

from . import constants


class Preferences:
    """Persistent application preferences that are not tied to an open file."""

    def __init__(self):
        self.settings = QSettings("binary-waterfall-x", "binary-waterfall-x")

    def timing_mode(self):
        value = self.settings.value(
            "playback/timing_mode",
            constants.DEFAULTS["timing_mode"].value,
            type=int
        )
        try:
            return constants.TimingModeCode(value)
        except ValueError:
            return constants.DEFAULTS["timing_mode"]

    def set_timing_mode(self, mode):
        self.settings.setValue("playback/timing_mode", mode.value)

    def bwv_quick_settings_enabled(self):
        return self.settings.value(
            "bwv/quick_settings_enabled",
            constants.DEFAULTS["bwv_quick_settings"],
            type=bool
        )

    def set_bwv_quick_settings_enabled(self, enabled):
        self.settings.setValue("bwv/quick_settings_enabled", enabled)

    def bwv_settings(self):
        color_value = self.settings.value(
            "bwv/color_mode",
            constants.DEFAULTS["bwv_color_mode"].value,
            type=int
        )
        try:
            color_mode = constants.ColorModeCode(color_value)
        except ValueError:
            color_mode = constants.DEFAULTS["bwv_color_mode"]

        return {
            "width": self.settings.value("bwv/width", constants.DEFAULTS["bwv_width"], type=int),
            "height": self.settings.value("bwv/height", constants.DEFAULTS["bwv_height"], type=int),
            "fps": self.settings.value("bwv/fps", constants.DEFAULTS["bwv_fps"], type=int),
            "sample_rate": self.settings.value(
                "bwv/sample_rate", constants.DEFAULTS["bwv_sample_rate"], type=int
            ),
            "color_mode": color_mode
        }

    def set_bwv_settings(self, values):
        self.settings.setValue("bwv/width", values["width"])
        self.settings.setValue("bwv/height", values["height"])
        self.settings.setValue("bwv/fps", values["fps"])
        self.settings.setValue("bwv/sample_rate", values["sample_rate"])
        self.settings.setValue("bwv/color_mode", values["color_mode"].value)
