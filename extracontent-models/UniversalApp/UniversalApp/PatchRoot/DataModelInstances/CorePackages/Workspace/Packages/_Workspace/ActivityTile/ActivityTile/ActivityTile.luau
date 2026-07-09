local Parent = script:FindFirstAncestor("ActivityTile").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local List = Foundation.List
local InputSize = Foundation.Enums.InputSize

local function ActivityTile(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), View (copy), List (copy), InputSize (copy)
	local v9 = if not t1.thumbnail then nil else {
		iconName = t1.thumbnail
	}
	local v10 = if not t1.isUnread then nil else React.createElement(View, {
		tag = "size-200-200 auto-none radius-circle bg-system-emphasis"
	})
	local v11 = if not t1.subtitle then t1.title else {
		title = t1.title,
		metadata = t1.subtitle
	}

	return React.createElement(List.Root, {
		hasDivider = false,
		size = InputSize.Large,
		LayoutOrder = t1.layoutOrder
	}, {
		Item = React.createElement(List.Item, {
			leading = v9,
			title = v11,
			trailing = v10,
			onActivated = t1.onActivated
		})
	})
end

return ActivityTile
