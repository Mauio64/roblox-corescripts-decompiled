local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View

require(parent.AvatarExperienceCommon)
local WearTimeListItem = require(script.Parent.WearTimeListItem)

local function WearTimeList(props)
	local children = {}

	for k, option in props.options do
		local v = "WearTimeListItem_" .. tostring(k)
		children[v] = React.createElement(WearTimeListItem, {
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
		View,
		{
			tag = "col gap-small size-full-0 auto-y padding-small radius-medium stroke-default stroke-thick",
			LayoutOrder = props.LayoutOrder
		},
		children
	)
end

return WearTimeList
