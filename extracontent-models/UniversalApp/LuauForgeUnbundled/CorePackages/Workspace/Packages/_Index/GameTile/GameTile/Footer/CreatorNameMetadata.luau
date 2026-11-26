local GridTileTextFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileTextFooter")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization").Hooks.useLocalization

local v5 = utf8.char(57344)

local function CreatorNameMetadata(props)
	local creatorByLabel = useLocalization({
		creatorByLabel = "Feature.GameDetails.Label.By"
	}).creatorByLabel

	local v6 = React.useMemo(function()
		if props.name == nil or props.name == "" then
			return ""
		end

		return `<b>{creatorByLabel} {props.name}</b>{not props.hasVerifiedBadge and "" or v5}`
	end, { creatorByLabel, props.name, props.hasVerifiedBadge })

	return React.createElement(GridTileTextFooter, {
		LayoutOrder = props.LayoutOrder,
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		RichText = true,
		text = v6,
		useLargerFont = true,
		isUnifiedGameTile = true
	})
end

return CreatorNameMetadata
