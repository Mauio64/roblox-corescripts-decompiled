local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local React = require(Parent.React)
local View = require(Parent.Foundation).View

require(Parent.AvatarExperienceCommon)

local WearTimeListItem = require(script.Parent.WearTimeListItem)

local function WearTimeList(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), WearTimeListItem (copy), View (copy)
	local t2 = {}

	for v8, v9 in t1.options do
		t2["WearTimeListItem_" .. tostring(v8)] = React.createElement(WearTimeListItem, {
			days = v9.days,
			price = v9.price,
			isActive = v9.selected ~= nil and v9.selected,
			onActivated = if not t1.onOptionActivated then nil else function() -- line: 26
				-- upvalues: t1 (copy), v8 (copy)
				t1.onOptionActivated(v8)
			end,
			LayoutOrder = v8
		})
	end

	return React.createElement(View, {
		tag = "col gap-small size-full-0 auto-y padding-small radius-medium stroke-default stroke-thick",
		LayoutOrder = t1.LayoutOrder
	}, t2)
end

return WearTimeList
