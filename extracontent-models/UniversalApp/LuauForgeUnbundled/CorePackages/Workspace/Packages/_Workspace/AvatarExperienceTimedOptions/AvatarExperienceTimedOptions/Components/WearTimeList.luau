local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Foundation").View

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceCommon")
local WearTimeListItem = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceTimedOptions/Components/WearTimeListItem")

local function WearTimeList(props)
	local children = {}

	for k, option in props.options do
		local v5 = "WearTimeListItem_" .. tostring(k)
		children[v5] = React.createElement(WearTimeListItem, {
			days = option.days,
			price = option.price,
			isActive = option.selected ~= nil and option.selected,
			onActivated = props.onOptionActivated and function()
				props.onOptionActivated(k)
			end or nil,
			LayoutOrder = k
		})
	end

	return React.createElement(
		view,
		{
			tag = "col gap-small size-full-0 auto-y padding-small radius-medium stroke-default stroke-thick",
			LayoutOrder = props.LayoutOrder
		},
		children
	)
end

return WearTimeList
