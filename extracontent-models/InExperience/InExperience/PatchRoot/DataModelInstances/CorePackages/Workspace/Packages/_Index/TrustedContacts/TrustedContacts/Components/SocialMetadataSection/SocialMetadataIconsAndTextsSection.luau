local parent = script:FindFirstAncestor("TrustedContacts").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

local BuilderIcons = require(parent.BuilderIcons)
local IconVariant = BuilderIcons.IconVariant

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local useProfileInsightsToIconsAndTexts = require(script.Parent.useProfileInsightsToIconsAndTexts)

local function SocialMetadataIconsAndTextsSection(data)
	local v = useProfileInsightsToIconsAndTexts(data.profileInsightIconItems)

	local v2 = { useDesignTokens(), (useTokens()) }
	local v3 = React.useCallback(function(p, layoutOrder)
		return React.createElement(
			View,
			{
				tag = "auto-xy size-0 row align-y-center gap-xsmall padding-x-xsmall",
				LayoutOrder = layoutOrder
			},
			{
				Icon = React.createElement(Icon, {
					name = p.icon,
					size = IconSize.XSmall,
					LayoutOrder = 1,
					variant = IconVariant.Filled
				}),
				Text = React.createElement(Text, {
					tag = "auto-xy size-0 text-align-x-left text-truncate-end text-body-medium",
					Text = p.text,
					LayoutOrder = 2
				})
			}
		)
	end, v2)

	local v4 = {}

	for k, v5 in pairs(v) do
		table.insert(v4, (v3(v5, k)))
	end

	return React.useMemo(function()
		return React.createElement(View, {
			tag = {
				["row auto-y size-full-0 wrap align-x-left"] = true,
				["gap-xsmall"] = data.isVerticallyConstrained,
				["gap-small"] = not data.isVerticallyConstrained
			},
			LayoutOrder = data.layoutOrder
		}, v4)
	end, { data.profileInsightIconItems, v4 })
end

return SocialMetadataIconsAndTextsSection
