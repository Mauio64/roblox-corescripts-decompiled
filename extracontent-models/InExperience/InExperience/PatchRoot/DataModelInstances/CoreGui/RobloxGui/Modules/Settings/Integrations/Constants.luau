local Settings = script:FindFirstAncestor("Settings")
local GameSettingsConstants = require(Settings.Resources.GameSettingsConstants)
local t1 = {
	PAGE_ID = "gamesettings",
	TAB_HEADER = {
		NAME = "GameSettingsTab",
		TEXT = "Settings",
		ICON = "icons/common/settings"
	},
	LAYOUT_ORDER = GameSettingsConstants.SETTINGS_MENU_LAYOUT_ORDER
}
local t2 = {
	TAB_HEADER = {
		NAME = "TraversalHistoryWrapper",
		TEXT_KEY = "CoreScripts.TopBar.Traversal.History"
	}
}

return {
	GAMESETTINGS = t1,
	TRAVERSAL_HISTORY = t2
}
