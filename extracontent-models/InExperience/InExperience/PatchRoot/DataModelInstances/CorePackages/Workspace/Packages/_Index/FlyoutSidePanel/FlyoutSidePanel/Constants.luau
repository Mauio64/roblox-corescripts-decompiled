local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent

local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutSidePanelIXP = SharedExperimentDefinition.FlyoutSidePanelIXP

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableChartsInFlyout = SharedFlags.FFlagEnableChartsInFlyout
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserLibrary = SharedFlags2.FFlagUserLibrary
local FFlagFlyoutAddAdjustScreen = require(script.Parent.Flags.FFlagFlyoutAddAdjustScreen)

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
			FFlagUserLibrary and "UserLibrary" or nil,
			"Favorites",
			"ContinuePlaying",
			FFlagEnableChartsInFlyout and FlyoutSidePanelIXP.isChartsInFlyoutEnabled() and "Charts" or nil,
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
			FFlagFlyoutAddAdjustScreen and "AdjustScreen" or nil,
			"HelpAndSafety"
		},
		AdditionalNavigation = { "Events", "Moments", "Learn", "CreateGames" }
	}
}
