local Parent = script:FindFirstAncestor("DiscoveryTypes").Parent

require(Parent.React)

local SharedFlags = require(Parent.SharedFlags)
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile

return {
	GameCollectionItemType = {
		GameTile = "GameTile",
		SeeAllTile = "SeeAllTile",
		EmphasisTile = "EmphasisTile",
		TwoByOneTile = "TwoByOneTile",
		Blank = "Blank",
		OneByTwoTile = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else "OneByTwoTile"
	},
	SpanForItemType = if not FFlagLuaAppEnableNxMRoduxApportioning then nil else {
		EmphasisTile = {
			colSpan = 2,
			rowSpan = 2
		},
		TwoByOneTile = {
			colSpan = 2,
			rowSpan = 1
		},
		OneByTwoTile = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else {
			colSpan = 1,
			rowSpan = 2
		}
	}
}
