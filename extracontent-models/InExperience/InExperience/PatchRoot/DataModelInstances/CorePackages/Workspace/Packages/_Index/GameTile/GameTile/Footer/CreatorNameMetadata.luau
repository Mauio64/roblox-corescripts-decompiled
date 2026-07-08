local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local GridTileTextFooter = require(GameTile.Footer.GridTileTextFooter)
local React = require(GameTileParent.React)
local useLocalization = require(GameTileParent.Localization).Hooks.useLocalization
local v6 = utf8.char(57344)

local function CreatorNameMetadata(t1: {[any]: any}) -- line: 18
	-- upvalues: useLocalization (copy), React (copy), v6 (copy), GridTileTextFooter (copy)
	local creatorByLabel = useLocalization({
		creatorByLabel = "Feature.GameDetails.Label.By"
	}).creatorByLabel
	local v10 = React.useMemo(function() -- line: 24
		-- upvalues: t1 (copy), creatorByLabel (copy), v6 (copy)
		if t1.name == nil or t1.name == "" then
			return ""
		end

		return `<b>{ creatorByLabel } { t1.name }</b>{ not t1.hasVerifiedBadge and "" or v6 }`
	end, {
		creatorByLabel,
		t1.name,
		t1.hasVerifiedBadge
	})

	return React.createElement(GridTileTextFooter, {
		RichText = true,
		useLargerFont = true,
		isUnifiedGameTile = true,
		LayoutOrder = t1.LayoutOrder,
		AnchorPoint = t1.AnchorPoint,
		Position = t1.Position,
		text = v10
	})
end

return CreatorNameMetadata
