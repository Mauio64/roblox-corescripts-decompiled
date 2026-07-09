local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local View = require(Parent.Foundation).View
local RoactGamepad = require(Parent.RoactGamepad)
local Focusable = RoactGamepad.Focusable

require(Parent.Dash)

local CheckboxButtonItem = require(script.Parent.CheckboxButtonItem)

local function CheckboxGroup(t1: {[any]: any}) -- line: 65
	-- upvalues: RoactGamepad (copy), React (copy), Focusable (copy), CheckboxButtonItem (copy), View (copy)
	local v10 = RoactGamepad.useRefCache()
	local v11, v12 = React.useBinding(0)
	local v13 = RoactGamepad.useRefCache()
	local v14 = React.useCallback(function() -- line: 71
		-- upvalues: t1 (copy), v13 (copy), v12 (copy)
		local n1 = 0

		for _, v25 in t1.items do
			n1 += v13[v25.id].current or 0
		end

		v12(n1)

		if t1.onHeightChanged then
			t1.onHeightChanged(n1)
		end
	end, {
		t1.items,
		v13,
		v12,
		t1.onHeightChanged
	})
	local t2 = {
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 1)
		})
	}

	for v16, v17 in t1.items do
		local v18 = false

		if t1.selectedValue then
			v18 = table.find(t1.selectedValue, v17.id) ~= nil
		end

		local v19 = v10["defaultChild-" .. v16]

		t2["checkboxItem" .. v17.id] = React.createElement(Focusable[CheckboxButtonItem], {
			id = v17.id,
			text = v17.text,
			onActivated = t1.onActivated,
			isSelected = v18,
			isDisabled = v17.isDisabled,
			layoutOrder = v16,
			itemHeight = t1.itemHeight,
			customView = v17.customView,
			expandedView = v17.expandedView,
			expandedViewHeight = v17.expandedViewHeight,
			useDefaultControlState = t1.useDefaultControlState,
			hideDivider = t1.hideDividers or v16 == #t1.items,
			ref = v10[v16],
			defaultChildRef = v19,
			defaultChild = v19,
			restorePreviousChildFocus = v18,
			NextSelectionUp = if not (v16 > 1) then nil else v10[v16 - 1],
			NextSelectionDown = if not (v16 < #t1.items) then nil else v10[v16 + 1],
			onHeightChanged = React.useCallback(function(n2: number) -- line: 116
				-- upvalues: v13 (copy), v17 (copy), v14 (copy)
				v13[v17.id].current = n2
				v14()
			end, {
				v17.id,
				v13,
				v14
			})
		})
	end

	local v20 = t1.items and #t1.items > 0

	return React.createElement(v20 and Focusable[View] or View, {
		BackgroundTransparency = 1,
		defaultChild = v20 and v10[1] or nil,
		Size = v11:map(function(p1) -- line: 127
			return UDim2.new(1, 0, 0, p1)
		end),
		LayoutOrder = t1.layoutOrder,
		NextSelectionLeft = t1.NextSelectionLeft,
		NextSelectionRight = t1.NextSelectionRight,
		NextSelectionDown = t1.NextSelectionDown,
		NextSelectionUp = t1.NextSelectionUp,
		restorePreviousChildFocus = v20 or nil,
		ref = t1.frameRef
	}, t2)
end

return React.forwardRef(function(p2, p3) -- line: 141
	-- upvalues: React (copy), CheckboxGroup (copy), Cryo (copy)
	return React.createElement(CheckboxGroup, Cryo.Dictionary.join(p2, {
		frameRef = p3
	}))
end)
