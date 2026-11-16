local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local GridTileTextFooter = require(GameTile.Footer.GridTileTextFooter)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local v = utf8.char(57344)

local function CreatorNameMetadata(props)
	local creatorByLabel = useLocalization({ creatorByLabel = "Feature.GameDetails.Label.By" }).creatorByLabel

	local text = React.useMemo(function()
		if props.name == nil or props.name == "" then
			return ""
		end

		return `<b>{creatorByLabel} {props.name}</b>{not props.hasVerifiedBadge and "" or v}`
	end, { creatorByLabel, props.name, props.hasVerifiedBadge })

	return React.createElement(GridTileTextFooter, {
		LayoutOrder = props.LayoutOrder,
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		RichText = true,
		text = text,
		useLargerFont = true,
		isUnifiedGameTile = true
	})
end

return CreatorNameMetadata
