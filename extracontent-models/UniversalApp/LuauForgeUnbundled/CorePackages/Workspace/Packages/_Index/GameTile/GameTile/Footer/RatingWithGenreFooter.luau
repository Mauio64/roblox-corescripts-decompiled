local GridTileIconTextFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileIconTextFooter")
local getGameStatsRatingPercentageText = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/getGameStatsRatingPercentageText")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local iconsstatusgamesrating_small = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox").App.ImageSet.Images["icons/status/games/rating_small"]

local function RatingWithGenreFooter(props)
	local v5 = getGameStatsRatingPercentageText(props.totalUpVotes, props.totalDownVotes) .. "%"

	return React.createElement(GridTileIconTextFooter, {
		Position = props.Position,
		icon = iconsstatusgamesrating_small,
		text = `{v5} • {props.genreText}`,
		useLargerFont = props.useLargerFont,
		isUnifiedGameTile = props.isUnifiedGameTile
	})
end

return React.memo(RatingWithGenreFooter)
