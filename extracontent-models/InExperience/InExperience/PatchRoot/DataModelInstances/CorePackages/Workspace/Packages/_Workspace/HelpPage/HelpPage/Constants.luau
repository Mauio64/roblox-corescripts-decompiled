local parent = script.Parent
local parent2 = parent.Parent
local Foundation = require(parent2.Foundation)

local ExtraKeysEnum = require(parent.Enums.ExtraKeysEnum)
local TouchControlsEnum = require(parent.Enums.TouchControlsEnum)
local Enums = Foundation.Enums
local IconName = Foundation.Enums.IconName

local FFlagHelpPageCCL = require(parent.Flags.FFlagHelpPageCCL)
local SharedFlags = require(parent2.SharedFlags)
local FFlagRenameHelpToControls = SharedFlags.FFlagRenameHelpToControls

local v = {
	ZOOM = Enums.IconName.HandDualArrows,
	TAP = Enums.IconName.HandHalfEllipse,
	ROTATE = Enums.IconName.HandCurvedArrowLeft
}

local v2 = {
	[ExtraKeysEnum.Fn] = 1,
	[Enum.KeyCode.LeftControl] = 2,
	[Enum.KeyCode.LeftAlt] = 3,
	[Enum.KeyCode.RightAlt] = 4,
	[Enum.KeyCode.LeftShift] = 5,
	[Enum.KeyCode.LeftSuper] = 6,
	[Enum.KeyCode.F1] = 7,
	[Enum.KeyCode.F2] = 8,
	[Enum.KeyCode.F3] = 9,
	[Enum.KeyCode.F4] = 10,
	[Enum.KeyCode.F5] = 11,
	[Enum.KeyCode.F6] = 12,
	[Enum.KeyCode.F7] = 13,
	[Enum.KeyCode.F8] = 14,
	[Enum.KeyCode.F9] = 15,
	[Enum.KeyCode.F10] = 16,
	[Enum.KeyCode.F11] = 17,
	[Enum.KeyCode.F12] = 18,
	[Enum.KeyCode.Up] = 160,
	[Enum.KeyCode.Left] = 161,
	[Enum.KeyCode.Right] = 162,
	[Enum.KeyCode.Down] = 163,
	[ExtraKeysEnum.NumSequence] = 164,
	[Enum.KeyCode.MouseLeftButton] = 165,
	[Enum.KeyCode.MouseMiddleButton] = 166,
	[ExtraKeysEnum.MouseWheel] = 167,
	[Enum.KeyCode.MouseRightButton] = 168
}

return {
	HELP_PAGE = {
		PAGE_ID = "helppage",
		TAB_HEADER = {
			NAME = "HelpTab",
			ICON = "icons/menu/help",
			TEXT = FFlagRenameHelpToControls and "CoreScripts.InGameMenu.Controls.ControlsPage" or "CoreScripts.Feedback.Help.MainHeader"
		},
		KEYCODES_LOCALIZED = {
			[ExtraKeysEnum.MouseWheel] = "CoreScripts.InGameMenu.Controls.MouseWheel",
			[Enum.KeyCode.Up] = "CoreScripts.InGameMenu.Controls.UpArrow",
			[Enum.KeyCode.Down] = "CoreScripts.InGameMenu.Controls.DownArrow",
			[Enum.KeyCode.Left] = "CoreScripts.InGameMenu.Controls.LeftArrow",
			[Enum.KeyCode.Right] = "CoreScripts.InGameMenu.Controls.RightArrow",
			[Enum.KeyCode.Space] = "CoreScripts.InGameMenu.Controls.Space",
			[Enum.KeyCode.Backspace] = "CoreScripts.InGameMenu.Controls.Backspace",
			[Enum.KeyCode.MouseLeftButton] = "CoreScripts.InGameMenu.Controls.LeftMouseButton",
			[Enum.KeyCode.MouseRightButton] = "CoreScripts.InGameMenu.Controls.RightMouseButton",
			[Enum.KeyCode.LeftShift] = "CoreScripts.InGameMenu.Controls.Shift"
		},
		KEYCODES_UNLOCALIZED = {
			[ExtraKeysEnum.Fn] = "Fn",
			[ExtraKeysEnum.NumSequence] = "1,2,3...",
			[Enum.KeyCode.LeftControl] = "Ctrl",
			[Enum.KeyCode.LeftAlt] = "Alt",
			[Enum.KeyCode.RightAlt] = "Opt",
			[Enum.KeyCode.LeftSuper] = "Cmd",
			[Enum.KeyCode.Escape] = "Esc",
			[Enum.KeyCode.Tab] = "Tab",
			[Enum.KeyCode.F1] = "F1",
			[Enum.KeyCode.F2] = "F2",
			[Enum.KeyCode.F3] = "F3",
			[Enum.KeyCode.F4] = "F4",
			[Enum.KeyCode.F5] = "F5",
			[Enum.KeyCode.F6] = "F6",
			[Enum.KeyCode.F7] = "F7",
			[Enum.KeyCode.F8] = "F8",
			[Enum.KeyCode.F9] = "F9",
			[Enum.KeyCode.F10] = "F10",
			[Enum.KeyCode.F11] = "F11",
			[Enum.KeyCode.F12] = "F12"
		},
		KEYCODE_ORDER = v2,
		SEPARATORS = { COMBO = " + ", ALTERNATIVE = "/" },
		GAMEPAD_PLAYSTATION_PLATFORMS = {
			[Enum.Platform.PS5] = true,
			[Enum.Platform.PS4] = true,
			[Enum.Platform.PS3] = true
		},
		GAMEPAD_LAYOUT_ORDER = {
			[Enum.KeyCode.ButtonL2] = 1,
			[Enum.KeyCode.ButtonL1] = 2,
			[Enum.KeyCode.ButtonSelect] = 3,
			[ExtraKeysEnum.TouchPad] = 4,
			[Enum.KeyCode.Thumbstick1] = 5,
			[Enum.KeyCode.DPadUp] = 6,
			[Enum.KeyCode.DPadLeft] = 7,
			[Enum.KeyCode.DPadRight] = 8,
			[Enum.KeyCode.DPadDown] = 9,
			[ExtraKeysEnum.DPad] = 10,
			[Enum.KeyCode.ButtonL3] = 11,
			[Enum.KeyCode.ButtonR3] = 12,
			[Enum.KeyCode.Thumbstick2] = 13,
			[Enum.KeyCode.ButtonA] = 14,
			[Enum.KeyCode.ButtonX] = 15,
			[Enum.KeyCode.ButtonB] = 16,
			[Enum.KeyCode.ButtonY] = 17,
			[Enum.KeyCode.ButtonStart] = 18,
			[Enum.KeyCode.ButtonR1] = 19,
			[Enum.KeyCode.ButtonR2] = 20
		},
		GAMEPAD_ICON_MAP_XBOX = {
			[Enum.KeyCode.ButtonL2] = IconName.XboxLt,
			[Enum.KeyCode.ButtonL1] = IconName.XboxLb,
			[Enum.KeyCode.ButtonSelect] = IconName.XboxView,
			[Enum.KeyCode.DPadUp] = IconName.XboxDpadUp,
			[Enum.KeyCode.DPadLeft] = IconName.XboxDpadLeft,
			[Enum.KeyCode.DPadRight] = IconName.XboxDpadRight,
			[Enum.KeyCode.DPadDown] = IconName.XboxDpadDown,
			[ExtraKeysEnum.DPad] = IconName.XboxDpad,
			[Enum.KeyCode.Thumbstick1] = IconName.XboxStickLeftDirectional,
			[Enum.KeyCode.ButtonL3] = IconName.XboxStickLeft,
			[Enum.KeyCode.ButtonR3] = IconName.XboxStickRight,
			[Enum.KeyCode.Thumbstick2] = IconName.XboxStickRightDirectional,
			[Enum.KeyCode.ButtonA] = IconName.XboxA,
			[Enum.KeyCode.ButtonX] = IconName.XboxX,
			[Enum.KeyCode.ButtonB] = IconName.XboxB,
			[Enum.KeyCode.ButtonY] = IconName.XboxY,
			[Enum.KeyCode.ButtonStart] = IconName.XboxMenu,
			[Enum.KeyCode.ButtonR1] = IconName.XboxRb,
			[Enum.KeyCode.ButtonR2] = IconName.XboxRt
		},
		GAMEPAD_ICON_MAP_PLAYSTATION = {
			[Enum.KeyCode.ButtonL2] = IconName.PsL2,
			[Enum.KeyCode.ButtonL1] = IconName.PsL1,
			[Enum.KeyCode.ButtonSelect] = IconName.Ps4Share,
			[ExtraKeysEnum.TouchPad] = IconName.Ps4Touchpad,
			[Enum.KeyCode.DPadUp] = IconName.PsDpadUp,
			[Enum.KeyCode.DPadLeft] = IconName.PsDpadLeft,
			[Enum.KeyCode.DPadRight] = IconName.PsDpadRight,
			[Enum.KeyCode.DPadDown] = IconName.PsDpadDown,
			[ExtraKeysEnum.DPad] = IconName.PsDpad,
			[Enum.KeyCode.Thumbstick1] = IconName.PsStickLeft,
			[Enum.KeyCode.ButtonL3] = IconName.PsL3,
			[Enum.KeyCode.ButtonR3] = IconName.PsR3,
			[Enum.KeyCode.Thumbstick2] = IconName.PsStickRight,
			[Enum.KeyCode.ButtonA] = IconName.PsX,
			[Enum.KeyCode.ButtonX] = IconName.PsSquare,
			[Enum.KeyCode.ButtonB] = IconName.PsCircle,
			[Enum.KeyCode.ButtonY] = IconName.PsTriagle,
			[Enum.KeyCode.ButtonStart] = IconName.Ps4Options,
			[Enum.KeyCode.ButtonR1] = IconName.PsR1,
			[Enum.KeyCode.ButtonR2] = IconName.PsR2
		},
		GAMEPAD_ICON_MAP_PLAYSTATION_5 = {
			[ExtraKeysEnum.TouchPad] = IconName.Ps5Touchpad,
			[Enum.KeyCode.ButtonSelect] = IconName.Ps5Share,
			[Enum.KeyCode.ButtonStart] = IconName.Ps5Options
		},
		GAMEPAD_ICON_MAP_SPATIAL = {
			[Enum.KeyCode.ButtonSelect] = IconName.XboxMenu,
			[Enum.KeyCode.Thumbstick1] = IconName.XboxStickLeftDirectional,
			[Enum.KeyCode.ButtonL3] = IconName.XboxStickLeft,
			[Enum.KeyCode.DPadDown] = IconName.XboxX,
			[Enum.KeyCode.DPadUp] = IconName.XboxY,
			[Enum.KeyCode.ButtonA] = IconName.XboxA,
			[Enum.KeyCode.ButtonB] = IconName.XboxB,
			[Enum.KeyCode.ButtonR3] = IconName.XboxStickRight,
			[Enum.KeyCode.Thumbstick2] = IconName.XboxStickRightDirectional
		},
		GAMEPAD_CUTOFFS = { LEFT_COL = 11, BOTTOM_RIGHT_COL = 13 },
		GAMEPAD_SIZES = {
			IMAGE_ASPECT_RATIO = 1.289,
			IMAGE_MULTIPLIER_DEFAULT = 0.5,
			COL_SCALE_PORTRAIT = 0.75,
			COL_SCALE_VR = 0.75,
			IMAGE_MULTIPLIER_PORTRAIT = 0.75,
			IMAGE_MULTIPLIER_VR = 0.45,
			LEFT_COL_SCALE = FFlagHelpPageCCL and 0.25 or 0.285,
			RIGHT_COL_SCALE = 0.75,
			RIGHT_COL_SCALE_VR = 0.715,
			NO_PADDING_CUTOFF_Y = 650,
			COL_SIZE = 0.25,
			COL_SIZE_PORTRAIT = 0.5
		},
		TOUCH_ENUM_TO_ICON = {
			[TouchControlsEnum.TopLeft] = v.ZOOM,
			[TouchControlsEnum.TopMidTap] = v.TAP,
			[TouchControlsEnum.TopMidRotate] = v.ROTATE,
			[TouchControlsEnum.TopRightTap] = v.TAP,
			[TouchControlsEnum.TopRightRotate] = v.ROTATE,
			[TouchControlsEnum.BottomLeftTap] = v.TAP,
			[TouchControlsEnum.BottomLeftRotate] = v.ROTATE,
			[TouchControlsEnum.BottomMid] = nil,
			[TouchControlsEnum.BottomRight] = v.TAP
		},
		TOUCH_ICONS = v,
		TOUCH_OFFSETS = {
			SMALL_SCREEN_CUTOFF_X = 700,
			SMALL_SCREEN_CUTOFF_Y = 500,
			SMALL_SCREEN_OFFSET = 150,
			BIG_SCREEN_OFFSET = 335
		}
	}
}
