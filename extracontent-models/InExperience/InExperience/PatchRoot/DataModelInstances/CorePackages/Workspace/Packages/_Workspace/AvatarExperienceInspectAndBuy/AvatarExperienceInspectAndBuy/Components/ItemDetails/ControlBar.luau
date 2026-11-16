local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Badge = require(AvatarExperienceInspectAndBuy.Components.Common.Badge)
local Enums = Foundation.Enums

local function ControlBar(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v = {
		tag = "auto-xy row align-x-left align-y-center gap-small",
		LayoutOrder = props.LayoutOrder
	}
	local v2 = {
		FavoritesBadge = React.createElement(Badge, {
			icon = Enums.IconName.Star,
			iconVariant = props.favoritesBadge.iconVariant,
			text = props.favoritesBadge.text,
			onActivated = props.favoritesBadge.onActivated,
			LayoutOrder = 1
		}),
		TryOnBadge = 0
	}
	local tryOnBadge

	if props.tryOnBadge then
		tryOnBadge = React.createElement(Badge, {
			icon = Enums.IconName.MirrorStanding,
			iconVariant = props.tryOnBadge.iconVariant,
			text = props.tryOnBadge.text,
			onActivated = props.tryOnBadge.onActivated,
			LayoutOrder = 2
		})
	end

	v2.TryOnBadge = tryOnBadge
	return createElement(view, v, v2)
end

return ControlBar
