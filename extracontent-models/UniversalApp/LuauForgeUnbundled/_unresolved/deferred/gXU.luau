local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
require(CorePackages.Packages.Dash)
local module = require("@luauforge/bundled/fuL")

local module2 = require("@luauforge/deferred/gXV")

local function RadioButtonGroup(props)
	local v5 = RoactGamepad.useRefCache()
	local v6 = useSelectionCursor(cursorKind.Square)

	local v7, v8 = React.useBinding(0)
	local v9 = RoactGamepad.useRefCache()

	local function updateTotalHeight()
		local total = 0

		for k, item in props.items do
			total += v9[item.id].current or 0
		end

		v8(total)

		if props.onHeightChanged then
			props.onHeightChanged(total)
		end
	end

	local children = {
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 1)
		})
	}

	for k, item in props.items do
		local v10 = props.selectedValue == item.id
		local v11 = v5["defaultChild-" .. k]

		local v12 = "radioButtonItem" .. item.id
		local createElement = React.createElement
		local v13 = focusable[module2]
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
			SelectionImageObject = 0,
			onHeightChanged = 0
		}

		local v15 = if k > 1 then v5[k - 1] else nil
		v14.NextSelectionUp = v15
		local v16 = if k < #props.items then v5[k + 1] else nil
		v14.NextSelectionDown = v16
		v14.SelectionImageObject = v6

		function v14.onHeightChanged(current)
			v9[item.id].current = current
			updateTotalHeight()
		end

		children[v12] = createElement(v13, v14)
	end

	local v10 = props.items and #props.items > 0

	return React.createElement(v10 and focusable.Frame or "Frame", {
		defaultChild = v10 and v5[1] or nil,
		Size = v7:map(module.mapHeightToSize),
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
	return React.createElement(RadioButtonGroup, Cryo.Dictionary.join(p2, {
		frameRef = p3
	}))
end)
