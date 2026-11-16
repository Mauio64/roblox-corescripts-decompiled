local CorePackages = game:GetService("CorePackages")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeShortcutRemoveLeaveOnRespawnPage = SharedFlags.FFlagChromeShortcutRemoveLeaveOnRespawnPage
local FFlagChromeShortcutRemoveRespawnOnLeavePage = SharedFlags.FFlagChromeShortcutRemoveRespawnOnLeavePage
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags.FFlagResponsiveUnitsDeprecateTenFoot

require(CorePackages.Packages.ReactOtter)
local TenFootInterface = require(script.Parent.Parent.Parent.Parent.TenFootInterface)
local UIBlox = require(CorePackages.Packages.UIBlox)
local GetStyleTokens = require(script.Parent.Parent.Utility.GetStyleTokens)

local IconSize = UIBlox.App.ImageSet.Enum.IconSize

local _ = { MouseAndKeyboard = "MouseAndKeyboard", Touch = "Touch", Gamepad = "Gamepad" }

local _ = { Landscape = "Landscape", Portrait = "Portrait", Sensor = "Sensor" }

local styleTokens = GetStyleTokens()

local function withUIScale(p: number) -- 21 equivalent calls inferred from this helper
	if FFlagResponsiveUnitsDeprecateTenFoot then
		return p
	end

	return (TenFootInterface:IsEnabled() and 1.5 or 1) * p
end

return {
	ICON_CELL_WIDTH = styleTokens.Size.Size_1100,
	DIVIDER_CELL_WIDTH = withUIScale(5), -- inferred equivalent call
	ICON_SIZE = styleTokens.Size.Size_900,
	ICON_NAME_PREFIX = FFlagEnableConsoleExpControls and "IconHitArea_" or nil,
	ICON_HIGHLIGHT_SIZE = UDim2.new(0, styleTokens.Size.Size_900, 0, styleTokens.Size.Size_900),
	ICON_DIVIDER_SIZE = UDim2.new(0, withUIScale(1), 0, styleTokens.Size.Size_700), -- inferred equivalent call
	ICON_DIVIDER_POSITION = UDim2.new(0, styleTokens.Size.Size_50, 0.5, 0),
	ICON_BADGE_OFFSET_X = styleTokens.Gap.XXLarge,
	ICON_BADGE_OFFSET_Y = withUIScale(5), -- inferred equivalent call
	MEDIUM_ICON_SIZE = styleTokens.Size.Size_700,
	UNIBAR_END_PADDING = styleTokens.Padding.XSmall,
	MENU_SUBMENU_PADDING = withUIScale(10), -- inferred equivalent call
	UNIBAR_LEFT_MARGIN = styleTokens.Padding.Small,
	MENU_ICON_SCREEN_SIDE_OFFSET = styleTokens.Gap.Large,
	SUB_MENU_ROW_HEIGHT = styleTokens.Size.Size_1400,
	SUBMENU_CORNER_RADIUS = withUIScale(10), -- inferred equivalent call
	SUBMENU_PADDING_LEFT = styleTokens.Padding.Small,
	SUBMENU_PADDING_RIGHT = styleTokens.Padding.Small,
	SUBMENU_ROW_LABEL_FONT = styleTokens.Typography.TitleLarge,
	SUBMENU_ROW_PADDING = styleTokens.Padding.Small,
	SUBMENU_ROW_CORNER_RADIUS = withUIScale(10), -- inferred equivalent call
	SUBMENU_BOTTOM_PADDING = styleTokens.Padding.XLarge,
	PIN_ICON_SIZE = UDim2.new(0, withUIScale(18), 0, withUIScale(18)), -- inferred equivalent call
	PIN_BUTTON_SIZE = styleTokens.Size.Size_1000,
	PIN_RIGHT_PADDING = withUIScale(13), -- inferred equivalent call
	PIN_CORNER_RADIUS = styleTokens.Radius.Medium,
	NEW_BADGE_SIZE = withUIScale(66), -- inferred equivalent call
	MENU_ANIMATION_SPRING = {
		dampingRatio = 1.1,
		frequency = 20 / 3,
		restingPositionLimit = 0.1,
		restingVelocityLimit = 0.05
	},
	UNIBAR_KEEP_OUT_AREA_ID = "unibar",
	SELFIE_VIEW_ID = "selfie_view",
	AVATAR_SWITCHER_ID = "avatar_switcher",
	SWITCH_SERVER_ID = "switch_server",
	IN_EXPERIENCE_SHOP_ID = "in_experience_shop",
	UNIBAR_SHORTCUTBAR_ID = "unibarShortcuts",
	TILTMENU_SHORTCUTBAR_ID = "tiltMenuShortcuts",
	TILTMENU_DIALOG_SHORTCUTBAR_ID = "tiltMenuDialogShortcuts",
	TILTMENU_RESPAWN_DIALOG_SHORTCUTBAR_ID = FFlagChromeShortcutRemoveLeaveOnRespawnPage and "tiltMenuRespawnDialogShortcuts" or nil,
	TILTMENU_LEAVE_DIALOG_SHORTCUTBAR_ID = FFlagChromeShortcutRemoveRespawnOnLeavePage and "tiltMenuLeaveDialogShortcuts" or nil,
	SHORTCUTBAR_DISPLAYORDER = 100,
	WINDOW_HOST_GUI_NAME = "WindowHost",
	CLOSE_BUTTON_FRAME = UDim2.fromOffset(styleTokens.Size.Size_1100, styleTokens.Size.Size_1100),
	CLOSE_BUTTON_SIZE = UDim2.fromOffset(withUIScale(22), withUIScale(22)), -- inferred equivalent call
	CLOSE_ICON_SIZE = IconSize.Small,
	CORNER_RADIUS = UDim.new(0, styleTokens.Radius.Medium),
	WINDOW_DEFAULT_PADDING = styleTokens.Padding.Small,
	WINDOW_ICON_SIZE = withUIScale(42), -- inferred equivalent call
	DRAG_MAGNITUDE_THRESHOLD = 10,
	WINDOW_MIN_DRAG_DISTANCE = 25,
	DEFAULT_HEIGHT_LARGE = withUIScale(285), -- inferred equivalent call
	DEFAULT_WIDTH_LARGE = withUIScale(176), -- inferred equivalent call
	DEFAULT_HEIGHT = withUIScale(130), -- inferred equivalent call
	DEFAULT_WIDTH = withUIScale(176), -- inferred equivalent call
	MAX_HEIGHT_PORTRAIT = withUIScale(285), -- inferred equivalent call
	MAX_WIDTH_PORTRAIT = withUIScale(260), -- inferred equivalent call
	MAX_HEIGHT_LANDSCAPE = withUIScale(285), -- inferred equivalent call
	MAX_WIDTH_LANDSCAPE = withUIScale(260), -- inferred equivalent call
	SOCIAL_SLOTS = 3,
	TOGGLE_SLOTS = 1,
	NINE_DOT_SLOTS = 1,
	CORE_SLOTS = 5,
	MOBILE_TINY_PORTRAIT_SLOTS = 5,
	MOBILE_PORTRAIT_SLOTS = 6,
	MOBILE_LANDSCAPE_SLOTS = 7,
	NON_MOBILE_SLOTS = 9,
	MAX_NUM_UNIVERSES_SHOWN = 5,
	ANALYTICS = {
		SCREEN_ORIENTATION_MAP = {
			[Enum.ScreenOrientation.LandscapeLeft] = "Landscape",
			[Enum.ScreenOrientation.LandscapeRight] = "Landscape",
			[Enum.ScreenOrientation.LandscapeSensor] = "Landscape",
			[Enum.ScreenOrientation.Portrait] = "Portrait",
			[Enum.ScreenOrientation.Sensor] = "Sensor"
		},
		INPUT_TYPE_MAP = {
			[Enum.UserInputType.MouseButton1] = "MouseAndKeyboard",
			[Enum.UserInputType.MouseButton2] = "MouseAndKeyboard",
			[Enum.UserInputType.MouseButton3] = "MouseAndKeyboard",
			[Enum.UserInputType.MouseWheel] = "MouseAndKeyboard",
			[Enum.UserInputType.MouseMovement] = "MouseAndKeyboard",
			[Enum.UserInputType.Keyboard] = "MouseAndKeyboard",
			[Enum.UserInputType.Gamepad1] = "Gamepad",
			[Enum.UserInputType.Gamepad2] = "Gamepad",
			[Enum.UserInputType.Gamepad3] = "Gamepad",
			[Enum.UserInputType.Gamepad4] = "Gamepad",
			[Enum.UserInputType.Gamepad5] = "Gamepad",
			[Enum.UserInputType.Gamepad6] = "Gamepad",
			[Enum.UserInputType.Gamepad7] = "Gamepad",
			[Enum.UserInputType.Gamepad8] = "Gamepad",
			[Enum.UserInputType.Touch] = "Touch"
		},
		ICON_ACTIVATED = "chrome_unibar_icon_activated",
		ICON_DRAG_START = "chrome_unibar_icon_drag_started",
		ICON_DRAG_END = "chrome_unibar_icon_drag_ended",
		WINDOW_DRAG_START = "chrome_unibar_window_drag_started",
		WINDOW_DRAG_END = "chrome_unibar_window_drag_ended",
		WINDOW_RESIZE = "chrome_unibar_window_resized",
		WINDOW_OPENED = "chrome_unibar_window_opened",
		WINDOW_CLOSED = "chrome_unibar_window_closed"
	}
}
