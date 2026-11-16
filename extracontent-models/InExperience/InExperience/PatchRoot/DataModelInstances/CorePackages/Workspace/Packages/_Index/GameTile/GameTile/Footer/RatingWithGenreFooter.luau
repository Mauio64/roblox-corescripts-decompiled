local GameTile = script:FindFirstAncestor("GameTile")
local GridTileIconTextFooter = require(GameTile.Footer.GridTileIconTextFooter)
local getGameStatsRatingPercentageText = require(GameTile.Footer.getGameStatsRatingPercentageText)

local parent = GameTile.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local iconsstatusgamesrating_small = UIBlox.App.ImageSet.Images["icons/status/games/rating_small"]

local function RatingWithGenreFooter(props)
	local v = getGameStatsRatingPercentageText(props.totalUpVotes, props.totalDownVotes) .. "%"

	return React.createElement(GridTileIconTextFooter, {
		Position = props.Position,
		icon = iconsstatusgamesrating_small,
		text = `{v} • {props.genreText}`,
		useLargerFont = props.useLargerFont,
		isUnifiedGameTile = props.isUnifiedGameTile
	})
end

return React.memo(RatingWithGenreFooter)
