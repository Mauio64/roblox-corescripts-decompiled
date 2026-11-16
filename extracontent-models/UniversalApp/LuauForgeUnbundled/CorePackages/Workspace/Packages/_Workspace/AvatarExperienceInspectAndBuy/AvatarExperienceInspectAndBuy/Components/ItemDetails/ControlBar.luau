local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local Badge = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/Badge")
local enums = Foundation.Enums

local function ControlBar(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "auto-xy row align-x-left align-y-center gap-small",
		LayoutOrder = props.LayoutOrder
	}
	local v6 = {
		FavoritesBadge = React.createElement(Badge, {
			icon = enums.IconName.Star,
			iconVariant = props.favoritesBadge.iconVariant,
			text = props.favoritesBadge.text,
			onActivated = props.favoritesBadge.onActivated,
			LayoutOrder = 1
		}),
		TryOnBadge = 0
	}

	local v7 = if props.tryOnBadge then React.createElement(Badge, {
		icon = enums.IconName.MirrorStanding,
		iconVariant = props.tryOnBadge.iconVariant,
		text = props.tryOnBadge.text,
		onActivated = props.tryOnBadge.onActivated,
		LayoutOrder = 2
	}) else nil
	v6.TryOnBadge = v7
	return createElement(view, v5, v6)
end

return ControlBar
