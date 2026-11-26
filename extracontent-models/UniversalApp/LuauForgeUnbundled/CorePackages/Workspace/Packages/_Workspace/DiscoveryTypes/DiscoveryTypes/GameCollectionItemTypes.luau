require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/React")
local fFlagLuaAppEnableNxMRoduxApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppEnableNxMRoduxApportioning

return {
	GameCollectionItemType = {
		GameTile = "GameTile",
		SeeAllTile = "SeeAllTile",
		EmphasisTile = "EmphasisTile",
		TwoByOneTile = "TwoByOneTile",
		OneByTwoTile = fFlagLuaAppEnableNxMRoduxApportioning and "OneByTwoTile" or nil,
		Blank = "Blank"
	},
	AlignmentType = { RightPin = "RightPin", LeftPin = "LeftPin", Default = "Default" },
	SpanForItemType = fFlagLuaAppEnableNxMRoduxApportioning and {
		EmphasisTile = { colSpan = 2, rowSpan = 2 },
		TwoByOneTile = { colSpan = 2, rowSpan = 1 },
		OneByTwoTile = { colSpan = 1, rowSpan = 2 }
	} or nil
}
