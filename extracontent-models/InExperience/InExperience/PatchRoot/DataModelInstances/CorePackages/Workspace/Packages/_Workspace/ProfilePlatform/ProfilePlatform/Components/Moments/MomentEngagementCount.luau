local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens

local function MomentEngagementCount(props)
	local v = useAbbreviatedNumberLocalization(props.count or 0)
	local v2 = useTokens()
	local onMedia = props.onMedia == true
	local white_100

	if onMedia then
		white_100 = v2.Color.Extended.White.White_100
	end

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.layoutOrder,
		tag = "row align-x-left align-y-center gap-xxsmall auto-xy"
	}

	local createElement2 = React.createElement
	local v4 = {
		LayoutOrder = 1,
		name = props.icon,
		size = IconSize.XSmall,
		variant = 0,
		style = 0
	}
	local variant

	if onMedia then
		variant = IconVariant.Filled
	end

	v4.variant = variant
	v4.style = white_100
	return createElement(View, v3, {
		Glyph = createElement2(Icon, v4),
		Count = React.createElement(Text, {
			LayoutOrder = 2,
			tag = {
				["auto-xy text-body-small"] = true,
				["content-default"] = not onMedia
			},
			textStyle = white_100,
			Text = v or ""
		})
	})
end

return MomentEngagementCount
