local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fxp")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/Style").useDesignTokens
local useLocalization = require("@luauforge/bundled/fxk").Hooks.useLocalization

local styledTextLabel = module2.App.Text.StyledTextLabel

local v5 = { emptyStateText = "Feature.Catalog.Search.LandingPage.Empty" }

local function mapTokens(p2)
	return {
		backgroundColor = p2.Color.Surface.Surface_0.Color3,
		backgroundTransparency = p2.Color.Surface.Surface_0.Transparency,
		textColorGroup = p2.Color.Content.Emphasis,
		textFontGroup = p2.Typography.BodyLarge
	}
end

local function SearchEmptyState(p2)
	local v6 = useLocalization(v5)
	local v7 = useDesignTokens(mapTokens)

	local text = p2.text or v6.emptyStateText

	return React.createElement(styledTextLabel, {
		fontStyle = v7.textFontGroup,
		colorStyle = v7.textColorGroup,
		text = text,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		automaticSize = Enum.AutomaticSize.XY,
		size = UDim2.fromScale(1, 1)
	})
end

return SearchEmptyState
