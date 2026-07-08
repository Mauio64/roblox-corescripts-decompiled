local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeShortcutRemoveLeaveOnRespawnPage = SharedFlags.FFlagChromeShortcutRemoveLeaveOnRespawnPage
local FFlagChromeShortcutRemoveRespawnOnLeavePage = SharedFlags.FFlagChromeShortcutRemoveRespawnOnLeavePage

require(CorePackages.Packages.ReactOtter)

local TenFootInterface = require(script.Parent.Parent.Parent.Parent.TenFootInterface)
local UIBlox = require(CorePackages.Packages.UIBlox)
local GetStyleTokens = require(script.Parent.Parent.Utility.GetStyleTokens)
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local _ = {
	MouseAndKeyboard = "MouseAndKeyboard",
	Touch = "Touch",
	Gamepad = "Gamepad"
}
local _ = {
	Landscape = "Landscape",
	Portrait = "Portrait",
	Sensor = "Sensor"
}
local v12 = GetStyleTokens()

local function withUIScale(n1: number) -- line: 34
	-- upvalues: TenFootInterface (copy)
	return (not TenFootInterface:IsEnabled() and 1 or 1.5) * n1
end

return {
	ICON_CELL_WIDTH = v12.Size.Size_1100,
	DIVIDER_CELL_WIDTH = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 5,
	ICON_SIZE = v12.Size.Size_900,
	ICON_NAME_PREFIX = if not FFlagEnableConsoleExpControls then nil else "IconHitArea_",
	ICON_HIGHLIGHT_SIZE = UDim2.new(0, v12.Size.Size_900, 0, v12.Size.Size_900),
	ICON_DIVIDER_SIZE = UDim2.new(0, (not TenFootInterface:IsEnabled() and 1 or 1.5) * 1, 0, v12.Size.Size_700),
	ICON_DIVIDER_POSITION = UDim2.new(0, v12.Size.Size_50, 0.5, 0),
	ICON_BADGE_OFFSET_X = v12.Gap.XXLarge,
	ICON_BADGE_OFFSET_Y = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 5,
	MEDIUM_ICON_SIZE = v12.Size.Size_700,
	UNIBAR_END_PADDING = v12.Padding.XSmall,
	MENU_SUBMENU_PADDING = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 10,
	UNIBAR_LEFT_MARGIN = v12.Padding.Small,
	MENU_ICON_SCREEN_SIDE_OFFSET = v12.Gap.Large,
	SUB_MENU_ROW_HEIGHT = v12.Size.Size_1400,
	SUBMENU_CORNER_RADIUS = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 10,
	SUBMENU_PADDING_LEFT = v12.Padding.Small,
	SUBMENU_PADDING_RIGHT = v12.Padding.Small,
	SUBMENU_ROW_LABEL_FONT = v12.Typography.TitleLarge,
	SUBMENU_ROW_PADDING = v12.Padding.Small,
	SUBMENU_ROW_CORNER_RADIUS = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 10,
	SUBMENU_BOTTOM_PADDING = v12.Padding.XLarge,
	PIN_ICON_SIZE = UDim2.new(0, (not TenFootInterface:IsEnabled() and 1 or 1.5) * 18, 0, (not TenFootInterface:IsEnabled() and 1 or 1.5) * 18),
	PIN_BUTTON_SIZE = v12.Size.Size_1000,
	PIN_RIGHT_PADDING = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 13,
	PIN_CORNER_RADIUS = v12.Radius.Medium,
	NEW_BADGE_SIZE = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 66,
	MENU_ANIMATION_SPRING = {
		dampingRatio = 1.1,
		frequency = 6.666666666666667,
		restingPositionLimit = 0.1,
		restingVelocityLimit = 0.05
	},
	UNIBAR_KEEP_OUT_AREA_ID = "unibar",
	SELFIE_VIEW_ID = "selfie_view",
	AVATAR_SWITCHER_ID = "avatar_switcher",
	IN_EXPERIENCE_SHOP_ID = "in_experience_shop",
	UNIBAR_SHORTCUTBAR_ID = "unibarShortcuts",
	TILTMENU_SHORTCUTBAR_ID = "tiltMenuShortcuts",
	TILTMENU_DIALOG_SHORTCUTBAR_ID = "tiltMenuDialogShortcuts",
	TILTMENU_RESPAWN_DIALOG_SHORTCUTBAR_ID = if not FFlagChromeShortcutRemoveLeaveOnRespawnPage then nil else "tiltMenuRespawnDialogShortcuts",
	TILTMENU_LEAVE_DIALOG_SHORTCUTBAR_ID = if not FFlagChromeShortcutRemoveRespawnOnLeavePage then nil else "tiltMenuLeaveDialogShortcuts",
	SHORTCUTBAR_DISPLAYORDER = 100,
	WINDOW_HOST_GUI_NAME = "WindowHost",
	CLOSE_BUTTON_FRAME = UDim2.fromOffset(v12.Size.Size_1100, v12.Size.Size_1100),
	CLOSE_BUTTON_SIZE = UDim2.fromOffset((not TenFootInterface:IsEnabled() and 1 or 1.5) * 22, (not TenFootInterface:IsEnabled() and 1 or 1.5) * 22),
	CLOSE_ICON_SIZE = IconSize.Small,
	CORNER_RADIUS = UDim.new(0, v12.Radius.Medium),
	WINDOW_DEFAULT_PADDING = v12.Padding.Small,
	WINDOW_ICON_SIZE = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 42,
	DRAG_MAGNITUDE_THRESHOLD = 10,
	WINDOW_MIN_DRAG_DISTANCE = 25,
	DEFAULT_HEIGHT_LARGE = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 285,
	DEFAULT_WIDTH_LARGE = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 176,
	DEFAULT_HEIGHT = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 130,
	DEFAULT_WIDTH = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 176,
	MAX_HEIGHT_PORTRAIT = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 285,
	MAX_WIDTH_PORTRAIT = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 260,
	MAX_HEIGHT_LANDSCAPE = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 285,
	MAX_WIDTH_LANDSCAPE = (not TenFootInterface:IsEnabled() and 1 or 1.5) * 260,
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
		ICON_ACTIVATED = "chrome_unibar_icon_activated",
		ICON_DRAG_START = "chrome_unibar_icon_drag_started",
		ICON_DRAG_END = "chrome_unibar_icon_drag_ended",
		WINDOW_DRAG_START = "chrome_unibar_window_drag_started",
		WINDOW_DRAG_END = "chrome_unibar_window_drag_ended",
		WINDOW_RESIZE = "chrome_unibar_window_resized",
		WINDOW_OPENED = "chrome_unibar_window_opened",
		WINDOW_CLOSED = "chrome_unibar_window_closed",
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
		}
	}
}
