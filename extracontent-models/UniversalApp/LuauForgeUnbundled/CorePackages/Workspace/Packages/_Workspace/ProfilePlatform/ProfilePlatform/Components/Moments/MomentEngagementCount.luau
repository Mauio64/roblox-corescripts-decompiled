local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local useAbbreviatedNumberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useAbbreviatedNumberLocalization

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens

local function MomentEngagementCount(props)
	local v5 = useAbbreviatedNumberLocalization(props.count or 0)
	local v6 = useTokens()
	local onMedia = props.onMedia == true
	local white_100 = if onMedia then v6.Color.Extended.White.White_100 else nil

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.layoutOrder,
		tag = "row align-x-left align-y-center gap-xxsmall auto-xy"
	}

	local createElement2 = React.createElement
	local v10 = {
		LayoutOrder = 1,
		name = props.icon,
		size = iconSize.XSmall,
		variant = 0,
		style = 0
	}
	local v11 = if onMedia then iconVariant.Filled else nil
	v10.variant = v11
	v10.style = white_100
	return createElement(view, v8, {
		Glyph = createElement2(icon, v10),
		Count = React.createElement(text, {
			LayoutOrder = 2,
			tag = {
				["auto-xy text-body-small"] = true,
				["content-default"] = not onMedia
			},
			textStyle = white_100,
			Text = v5 or ""
		})
	})
end

return MomentEngagementCount
