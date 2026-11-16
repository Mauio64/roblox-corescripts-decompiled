local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local RoactGamepad = require(parent.RoactGamepad)
local Focusable = RoactGamepad.Focusable
require(parent.Dash)

local CheckboxButtonItem = require(script.Parent.CheckboxButtonItem)

local function CheckboxGroup(props)
	local v = RoactGamepad.useRefCache()

	local v2, v3 = React.useBinding(0)
	local v4 = RoactGamepad.useRefCache()

	local v5 = React.useCallback(function()
		local total = 0

		for _, item in props.items do
			total += v4[item.id].current or 0
		end

		v3(total)

		if props.onHeightChanged then
			props.onHeightChanged(total)
		end
	end, { props.items, v4, v3, props.onHeightChanged })

	local children = {
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 1)
		})
	}

	for k, item in props.items do
		local v6

		if props.selectedValue then
			v6 = table.find(props.selectedValue, item.id) ~= nil
		else
			v6 = false
		end

		local v7 = v["defaultChild-" .. k]

		local v8 = "checkboxItem" .. item.id
		local createElement = React.createElement
		local v9 = Focusable[CheckboxButtonItem]
		local v10 = {
			id = item.id,
			text = item.text,
			onActivated = props.onActivated,
			isSelected = v6,
			isDisabled = item.isDisabled,
			layoutOrder = k,
			itemHeight = props.itemHeight,
			customView = item.customView,
			expandedView = item.expandedView,
			expandedViewHeight = item.expandedViewHeight,
			useDefaultControlState = props.useDefaultControlState,
			hideDivider = props.hideDividers or k == #props.items,
			ref = v[k],
			defaultChildRef = v7,
			defaultChild = v7,
			restorePreviousChildFocus = v6,
			NextSelectionUp = 0,
			NextSelectionDown = 0,
			onHeightChanged = 0
		}
		local nextSelectionUp

		if k > 1 then
			nextSelectionUp = v[k - 1]
		end

		v10.NextSelectionUp = nextSelectionUp
		local nextSelectionDown

		if k < #props.items then
			nextSelectionDown = v[k + 1]
		end

		v10.NextSelectionDown = nextSelectionDown

		v10.onHeightChanged = React.useCallback(function(current: number)
			v4[item.id].current = current
			v5()
		end, { item.id, v4, v5 })
		children[v8] = createElement(v9, v10)
	end

	local v6 = props.items and #props.items > 0

	return React.createElement(v6 and Focusable[View] or View, {
		defaultChild = v6 and v[1] or nil,
		Size = v2:map(function(p)
			return UDim2.new(1, 0, 0, p)
		end),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionUp = props.NextSelectionUp,
		restorePreviousChildFocus = v6 or nil,
		ref = props.frameRef
	}, children)
end

return React.forwardRef(function(p, frameRef)
	return React.createElement(CheckboxGroup, Cryo.Dictionary.join(p, { frameRef = frameRef }))
end)
