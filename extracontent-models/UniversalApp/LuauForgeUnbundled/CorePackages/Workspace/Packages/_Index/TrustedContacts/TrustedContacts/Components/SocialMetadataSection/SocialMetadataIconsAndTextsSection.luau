local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Foundation")
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize

local iconVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/BuilderIcons").IconVariant

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Style").useDesignTokens

local useProfileInsightsToIconsAndTexts = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/SocialMetadataSection/useProfileInsightsToIconsAndTexts")

local function SocialMetadataIconsAndTextsSection(data)
	local v5 = useProfileInsightsToIconsAndTexts(data.profileInsightIconItems)

	local v6 = { useDesignTokens(), (useTokens()) }
	local v7 = React.useCallback(function(p2, p3)
		return React.createElement(
			view,
			{
				tag = "auto-xy size-0 row align-y-center gap-xsmall padding-x-xsmall",
				LayoutOrder = p3
			},
			{
				Icon = React.createElement(icon, {
					name = p2.icon,
					size = iconSize.XSmall,
					LayoutOrder = 1,
					variant = iconVariant.Filled
				}),
				Text = React.createElement(text, {
					tag = "auto-xy size-0 text-align-x-left text-truncate-end text-body-medium",
					Text = p2.text,
					LayoutOrder = 2
				})
			}
		)
	end, v6)

	local v8 = {}

	for k, v9 in pairs(v5) do
		table.insert(v8, (v7(v9, k)))
	end

	return React.useMemo(function()
		return React.createElement(view, {
			tag = {
				["row auto-y size-full-0 wrap align-x-left"] = true,
				["gap-xsmall"] = data.isVerticallyConstrained,
				["gap-small"] = not data.isVerticallyConstrained
			},
			LayoutOrder = data.layoutOrder
		}, v8)
	end, { data.profileInsightIconItems, v8 })
end

return SocialMetadataIconsAndTextsSection
