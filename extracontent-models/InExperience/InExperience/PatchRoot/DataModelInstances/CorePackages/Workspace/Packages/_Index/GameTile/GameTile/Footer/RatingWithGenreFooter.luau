local GameTile = script:FindFirstAncestor("GameTile")
local GridTileIconTextFooter = require(GameTile.Footer.GridTileIconTextFooter)
local getGameStatsRatingPercentageText = require(GameTile.Footer.getGameStatsRatingPercentageText)
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local v6 = require(GameTileParent.UIBlox).App.ImageSet.Images["icons/status/games/rating_small"]

local function RatingWithGenreFooter(t1: {[any]: any}) -- line: 22
	-- upvalues: getGameStatsRatingPercentageText (copy), React (copy), GridTileIconTextFooter (copy), v6 (copy)
	local v9 = getGameStatsRatingPercentageText(t1.totalUpVotes, t1.totalDownVotes) .. "%"

	return React.createElement(GridTileIconTextFooter, {
		Position = t1.Position,
		icon = v6,
		text = `{ v9 } • { t1.genreText }`,
		useLargerFont = t1.useLargerFont,
		isUnifiedGameTile = t1.isUnifiedGameTile
	})
end

return React.memo(RatingWithGenreFooter)
