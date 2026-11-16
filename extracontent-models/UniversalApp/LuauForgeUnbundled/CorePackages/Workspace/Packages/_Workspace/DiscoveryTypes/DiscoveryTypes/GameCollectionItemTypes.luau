require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags")
local fFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local fFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile

return {
	GameCollectionItemType = {
		GameTile = "GameTile",
		SeeAllTile = "SeeAllTile",
		EmphasisTile = "EmphasisTile",
		TwoByOneTile = "TwoByOneTile",
		OneByTwoTile = fFlagLuaAppEnableHomepageOneByTwoTile and "OneByTwoTile" or nil,
		Blank = "Blank"
	},
	AlignmentType = { RightPin = "RightPin", LeftPin = "LeftPin", Default = "Default" },
	SpanForItemType = fFlagLuaAppEnableNxMRoduxApportioning and {
		EmphasisTile = { colSpan = 2, rowSpan = 2 },
		TwoByOneTile = { colSpan = 2, rowSpan = 1 },
		OneByTwoTile = fFlagLuaAppEnableHomepageOneByTwoTile and {
			colSpan = 1,
			rowSpan = 2
		} or nil
	} or nil
}
