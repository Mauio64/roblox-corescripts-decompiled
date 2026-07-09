local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconVariant = require(Parent.BuilderIcons).IconVariant
local useDesignTokens = require(Parent.Style).useDesignTokens
local useProfileInsightsToIconsAndTexts = require(script.Parent.useProfileInsightsToIconsAndTexts)

local function SocialMetadataIconsAndTextsSection(t1: {[any]: any}) -- line: 28
	-- upvalues: useProfileInsightsToIconsAndTexts (copy), useDesignTokens (copy), useTokens (copy), React (copy), View (copy), Icon (copy), IconSize (copy), IconVariant (copy), FoundationText (copy)
	local v14 = useProfileInsightsToIconsAndTexts(t1.profileInsightIconItems)
	local v15 = useDesignTokens()
	local v16 = useTokens()
	local v17 = React.useCallback(function(t2: {[any]: any}, p1) -- line: 34
		-- upvalues: React (copy), View (copy), Icon (copy), IconSize (copy), IconVariant (copy), FoundationText (copy)
		return React.createElement(View, {
			tag = "auto-xy size-0 row align-y-center gap-xsmall padding-x-xsmall",
			LayoutOrder = p1
		}, {
			Icon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = t2.icon,
				size = IconSize.XSmall,
				variant = IconVariant.Filled
			}),
			Text = React.createElement(FoundationText, {
				tag = "auto-xy size-0 text-align-x-left text-truncate-end text-body-medium",
				LayoutOrder = 2,
				Text = t2.text
			})
		})
	end, {
		v15,
		v16
	})
	local t3 = {}

	for k, v in pairs(v14) do
		table.insert(t3, (v17(v, k)))
	end

	return React.useMemo(function() -- line: 59
		-- upvalues: React (copy), View (copy), t1 (copy), t3 (copy)
		return React.createElement(View, {
			tag = {
				["row auto-y size-full-0 wrap align-x-left"] = true,
				["gap-xsmall"] = t1.isVerticallyConstrained,
				["gap-small"] = not t1.isVerticallyConstrained
			},
			LayoutOrder = t1.layoutOrder
		}, t3)
	end, {
		t1.profileInsightIconItems,
		t3
	})
end

return SocialMetadataIconsAndTextsSection
