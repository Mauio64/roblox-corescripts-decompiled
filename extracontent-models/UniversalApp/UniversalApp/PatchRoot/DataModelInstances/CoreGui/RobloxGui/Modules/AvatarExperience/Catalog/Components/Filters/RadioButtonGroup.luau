local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable

require(CorePackages.Packages.Dash)

local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local RadioButtonItem = require(script.Parent.RadioButtonItem)

local function RadioButtonGroup(t1: {[any]: any}) -- line: 68
	-- upvalues: RoactGamepad (copy), useSelectionCursor (copy), CursorKind (copy), React (copy), Focusable (copy), RadioButtonItem (copy), FilterUtils (copy)
	local v14 = RoactGamepad.useRefCache()
	local v15 = useSelectionCursor(CursorKind.Square)
	local v16, v17 = React.useBinding(0)
	local v18 = RoactGamepad.useRefCache()

	local function updateTotalHeight() -- line: 75
		-- upvalues: t1 (copy), v18 (copy), v17 (copy)
		local n1 = 0

		for _, v30 in t1.items do
			n1 += v18[v30.id].current or 0
		end

		v17(n1)

		if t1.onHeightChanged then
			t1.onHeightChanged(n1)
		end
	end

	local t2 = {
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 1)
		})
	}

	for v21, v22 in t1.items do
		local v23 = t1.selectedValue == v22.id
		local v24 = v14["defaultChild-" .. v21]

		t2["radioButtonItem" .. v22.id] = React.createElement(Focusable[RadioButtonItem], {
			id = v22.id,
			text = v22.text,
			onActivated = t1.onActivated,
			isSelected = v23,
			isDisabled = v22.isDisabled,
			layoutOrder = v21,
			itemHeight = t1.itemHeight,
			customView = v22.customView,
			expandedView = v22.expandedView,
			expandedViewHeight = v22.expandedViewHeight,
			useDefaultControlState = t1.useDefaultControlState,
			hideDivider = t1.hideDividers or v21 == #t1.items,
			ref = v14[v21],
			defaultChildRef = v24,
			defaultChild = v24,
			restorePreviousChildFocus = v23,
			NextSelectionUp = if not (v21 > 1) then nil else v14[v21 - 1],
			NextSelectionDown = if not (v21 < #t1.items) then nil else v14[v21 + 1],
			SelectionImageObject = v15,
			onHeightChanged = function(n2: number) -- line: 118
				-- upvalues: v18 (copy), v22 (copy), updateTotalHeight (copy)
				v18[v22.id].current = n2
				updateTotalHeight()
			end
		})
	end

	local v25 = t1.items and #t1.items > 0

	return React.createElement(v25 and Focusable.Frame or "Frame", {
		BackgroundTransparency = 1,
		defaultChild = v25 and v14[1] or nil,
		Size = v16:map(FilterUtils.mapHeightToSize),
		LayoutOrder = t1.layoutOrder,
		NextSelectionLeft = t1.NextSelectionLeft,
		NextSelectionRight = t1.NextSelectionRight,
		NextSelectionDown = t1.NextSelectionDown,
		NextSelectionUp = t1.NextSelectionUp,
		restorePreviousChildFocus = v25 or nil,
		ref = t1.frameRef
	}, t2)
end

return React.forwardRef(function(p1, p2) -- line: 141
	-- upvalues: React (copy), RadioButtonGroup (copy), Cryo (copy)
	return React.createElement(RadioButtonGroup, Cryo.Dictionary.join(p1, {
		frameRef = p2
	}))
end)
