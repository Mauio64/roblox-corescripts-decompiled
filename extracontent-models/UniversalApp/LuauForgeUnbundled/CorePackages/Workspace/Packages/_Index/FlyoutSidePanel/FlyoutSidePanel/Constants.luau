local flyoutSidePanelIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedExperimentDefinition").FlyoutSidePanelIXP

local fFlagEnableChartsInFlyout = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagEnableChartsInFlyout
return {
	FLYOUT_SIDE_PANEL_WIDTH = 351,
	FLYOUT_SIDE_PADDING = 42,
	FAVORITES_URI = "roblox://navigation/experience_sort?sortId=Favorites",
	CONTINUE_PLAYING_URI = "roblox://navigation/experience_sort?sortId=Continue",
	SORT_ID_FAVORITES = "100000001",
	SORT_ID_CONTINUE_PLAYING = "100000003",
	ROBLOX_LOGO_ASPECT_RATIO = 47 / 9,
	MAX_SHOWN_STATUS_INDICATOR_COUNT = 99,
	FLYOUT_DEFAULT_POLICY = {
		MyLibrary = {
			require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagUserLibrary and "UserLibrary" or nil,
			"Favorites",
			"ContinuePlaying",
			fFlagEnableChartsInFlyout and flyoutSidePanelIXP.isChartsInFlyoutEnabled() and "Charts" or nil,
			"Connections",
			"Communities",
			"Inventory",
			"Trades",
			"Messages",
			"Blackbird",
			"Premium",
			"GiftCards",
			"Redeem",
			"Settings",
			"HelpAndSafety"
		},
		AdditionalNavigation = { "Events", "Moments", "Learn", "CreateGames" }
	}
}
