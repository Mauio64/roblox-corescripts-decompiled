local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Cryo")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation").View
local RoactGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/RoactGamepad")
local focusable = RoactGamepad.Focusable
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Dash")

local CheckboxButtonItem = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/Filters/CheckboxButtonItem")

local function CheckboxGroup(props)
	local v5 = RoactGamepad.useRefCache()

	local v6, v7 = React.useBinding(0)
	local v8 = RoactGamepad.useRefCache()

	local v9 = React.useCallback(function()
		local total = 0

		for k, item in props.items do
			total += v8[item.id].current or 0
		end

		v7(total)

		if props.onHeightChanged then
			props.onHeightChanged(total)
		end
	end, { props.items, v8, v7, props.onHeightChanged })

	local children = {
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 1)
		})
	}

	for k, item in props.items do
		local v10 = if props.selectedValue then table.find(props.selectedValue, item.id) ~= nil else false

		local v11 = v5["defaultChild-" .. k]

		local v12 = "checkboxItem" .. item.id
		local createElement = React.createElement
		local v13 = focusable[CheckboxButtonItem]
		local v14 = {
			id = item.id,
			text = item.text,
			onActivated = props.onActivated,
			isSelected = v10,
			isDisabled = item.isDisabled,
			layoutOrder = k,
			itemHeight = props.itemHeight,
			customView = item.customView,
			expandedView = item.expandedView,
			expandedViewHeight = item.expandedViewHeight,
			useDefaultControlState = props.useDefaultControlState,
			hideDivider = props.hideDividers or k == #props.items,
			ref = v5[k],
			defaultChildRef = v11,
			defaultChild = v11,
			restorePreviousChildFocus = v10,
			NextSelectionUp = 0,
			NextSelectionDown = 0,
			onHeightChanged = 0
		}

		local v15 = if k > 1 then v5[k - 1] else nil
		v14.NextSelectionUp = v15
		local v16 = if k < #props.items then v5[k + 1] else nil
		v14.NextSelectionDown = v16

		v14.onHeightChanged = React.useCallback(function(current)
			v8[item.id].current = current
			v9()
		end, { item.id, v8, v9 })
		children[v12] = createElement(v13, v14)
	end

	local v10 = props.items and #props.items > 0

	return React.createElement(v10 and focusable[view] or view, {
		defaultChild = v10 and v5[1] or nil,
		Size = v6:map(function(p2)
			return UDim2.new(1, 0, 0, p2)
		end),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionUp = props.NextSelectionUp,
		restorePreviousChildFocus = v10 or nil,
		ref = props.frameRef
	}, children)
end

return React.forwardRef(function(p2, p3)
	return React.createElement(CheckboxGroup, Cryo.Dictionary.join(p2, {
		frameRef = p3
	}))
end)
