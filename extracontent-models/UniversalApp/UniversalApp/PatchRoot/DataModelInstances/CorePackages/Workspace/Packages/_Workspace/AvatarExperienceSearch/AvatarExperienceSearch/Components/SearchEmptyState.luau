local Parent = script:FindFirstAncestor("AvatarExperienceSearch").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(Parent.Style).useDesignTokens
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local t1 = {
	emptyStateText = "Feature.Catalog.Search.LandingPage.Empty"
}

local function mapTokens(p1) -- line: 18
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		backgroundColor = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Background.Default else p1.Color.Surface.Surface_0)).Color3,
		backgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Background.Default else p1.Color.Surface.Surface_0)).Transparency,
		textColorGroup = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Emphasis else p1.Color.Content.Emphasis,
		textFontGroup = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.Body else p1.Typography.BodyLarge
	}
end
local function SearchEmptyState(t2: {[any]: any}) -- line: 39
	-- upvalues: useLocalization (copy), t1 (copy), useDesignTokens (copy), mapTokens (copy), React (copy), StyledTextLabel (copy)
	local v13 = useLocalization(t1)
	local v14 = useDesignTokens(mapTokens)
	local v15 = t2.text or v13.emptyStateText

	return React.createElement(StyledTextLabel, {
		fontStyle = v14.textFontGroup,
		colorStyle = v14.textColorGroup,
		text = v15,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		automaticSize = Enum.AutomaticSize.XY,
		size = UDim2.fromScale(1, 1)
	})
end

return SearchEmptyState
