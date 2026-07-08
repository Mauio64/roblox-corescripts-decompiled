local Settings = script:FindFirstAncestor("Settings")
local GameSettingsConstants = require(Settings.Resources.GameSettingsConstants)

return {
	GAMESETTINGS = {
		PAGE_ID = "gamesettings",
		TAB_HEADER = {
			NAME = "GameSettingsTab",
			TEXT = "Settings",
			ICON = "icons/common/settings"
		},
		LAYOUT_ORDER = GameSettingsConstants.SETTINGS_MENU_LAYOUT_ORDER
	}
}
