local parent = script:FindFirstAncestor("DiscoveryTypes").Parent
require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile

return {
	GameCollectionItemType = {
		GameTile = "GameTile",
		SeeAllTile = "SeeAllTile",
		EmphasisTile = "EmphasisTile",
		TwoByOneTile = "TwoByOneTile",
		OneByTwoTile = FFlagLuaAppEnableHomepageOneByTwoTile and "OneByTwoTile" or nil,
		Blank = "Blank"
	},
	AlignmentType = { RightPin = "RightPin", LeftPin = "LeftPin", Default = "Default" },
	SpanForItemType = FFlagLuaAppEnableNxMRoduxApportioning and {
		EmphasisTile = { colSpan = 2, rowSpan = 2 },
		TwoByOneTile = { colSpan = 2, rowSpan = 1 },
		OneByTwoTile = FFlagLuaAppEnableHomepageOneByTwoTile and { colSpan = 1, rowSpan = 2 } or nil
	} or nil
}
