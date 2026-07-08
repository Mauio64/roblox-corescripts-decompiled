local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Core = ParentParentParent.Core
local React = require(ParentParentParentParent.React)
local t = require(ParentParentParentParent.t)
local Otter = require(ParentParentParentParent.Otter)
local Cryo = require(ParentParentParentParent.Cryo)
local RoactGamepad = require(ParentParentParentParent.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local TileSlot = require(script.Parent.TileSlot)
local useStyle = require(Core.Style.useStyle)
local CursorKind = require(ParentParent.SelectionImage.CursorKind)
local useSelectionCursor = require(ParentParent.SelectionImage.useSelectionCursor)
local t1 = {
	dampingRatio = 1,
	frequency = 10
}
local v16 = t.strictInterface({
	displayText = t.optional(t.string),
	thumbnail = t.optional(t.string),
	isDisabled = t.optional(t.boolean),
	isLoading = t.optional(t.boolean)
})
local v17 = t.strictInterface({
	slots = t.array(v16),
	defaultSelectedSlotIndex = t.optional(t.integer),
	onChange = t.callback,
	width = t.optional(t.integer),
	darken = t.optional(t.boolean),
	onInputBegan = t.optional(t.callback),
	onInputEnded = t.optional(t.callback),
	scrollingFrameRef = t.optional(t.table),
	onFocusChanged = t.optional(t.callback),
	inputBindings = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	isRoactGamepadEnabled = t.optional(t.boolean)
})

local function useScrollingFrameMotor(p1, n1: number?) -- line: 117
	-- upvalues: React (copy), Otter (copy)
	local v22 = React.useRef(nil)

	if v22.current == nil then
		v22.current = Otter.createSingleMotor(n1 or 0)
	end

	local current = v22.current

	React.useEffect(function() -- line: 123
		-- upvalues: current (copy), p1 (copy)
		current:onStep(function(p2) -- line: 124
			-- upvalues: p1 (copy)
			if p1.current ~= nil then
				p1.current.CanvasPosition = Vector2.new(p2, 0)
			end
		end)

		return function() -- line: 130
			-- upvalues: current (copy)
			current:destroy()
		end
	end, {})

	return current
end
local function SlotTray(t2: {[any]: any}) -- line: 138
	-- upvalues: React (copy), RoactGamepad (copy), useScrollingFrameMotor (copy), Otter (copy), t1 (copy), useStyle (copy), useSelectionCursor (copy), CursorKind (copy), v17 (copy), Cryo (copy), Focusable (copy), TileSlot (copy)
	local v25 = t2.isRoactGamepadEnabled == nil or t2.isRoactGamepadEnabled
	local v26 = React.useRef({})
	local v27 = if not v25 then v26.current else RoactGamepad.useRefCache()
	local u28 = React.useRef(nil)

	if t2.scrollingFrameRef then
		u28 = t2.scrollingFrameRef
	end

	local v29 = t2.width or 360
	local v30 = useScrollingFrameMotor(u28, 0)
	local v31, v32 = React.useState(t2.defaultSelectedSlotIndex or 1)

	React.useEffect(function() -- line: 155
		-- upvalues: u28 (ref), v31 (copy), v27 (copy), v29 (copy), v30 (copy), Otter (copy), t1 (copy)
		local current = u28.current

		if v31 == 0 or not current then
			return
		end

		local v40 = v27[v31] and v27[v31].current

		if not v40 then
			return
		end

		local CanvasPositionX = current.CanvasPosition.X
		local AbsolutePositionX = current.AbsolutePosition.X
		local v43 = AbsolutePositionX + v29
		local AbsolutePositionX2 = v40.AbsolutePosition.X
		local v45 = AbsolutePositionX2 + 48 + 24 - v43
		local v46 = AbsolutePositionX2 - 24 - AbsolutePositionX
		local v47 = CanvasPositionX + v45
		local v48 = CanvasPositionX + v46

		if CanvasPositionX < v47 then
			v30:setGoal(Otter.spring(v47, t1))

			return
		end

		if v48 < CanvasPositionX then
			v30:setGoal(Otter.spring(v48, t1))
		end
	end, {
		v31,
		v29,
		v27,
		u28,
		v30
	})

	local v33 = React.useCallback(function(p3) -- line: 187
		-- upvalues: v32 (copy), t2 (copy)
		v32(p3)
		t2.onChange(p3)
	end, { t2.onChange })
	local v34 = #t2.slots * 48 + (#t2.slots - 1) * 12 + 48
	local v35 = useStyle()
	local v36 = useSelectionCursor(CursorKind.RoundedSlot)

	assert(v17(t2))

	local Theme = v35.Theme
	local v38 = Cryo.List.map(t2.slots, function(p4, p5) -- line: 200
		-- upvalues: v25 (copy), v27 (copy), React (copy), Focusable (copy), t2 (copy), v33 (copy), v36 (copy), TileSlot (copy), v31 (copy)
		if not v25 then
			v27[p5] = v27[p5] or React.createRef()
		end

		return React.createElement(not v25 and "Frame" or Focusable.Frame, {
			BackgroundTransparency = 1,
			BorderSizePixel = 2,
			key = "Slot" .. tostring(p5),
			LayoutOrder = p5,
			Size = UDim2.fromOffset(48, 48),
			ref = v27[p5],
			NextSelectionRight = p5 < #t2.slots and v27[p5 + 1] or nil,
			NextSelectionLeft = p5 > 1 and v27[p5 - 1] or nil,
			onFocusGained = if not v25 then nil else function() -- line: 215
				-- upvalues: v33 (copy), p5 (copy)
				v33(p5)
			end,
			SelectionImageObject = v36
		}, {
			Slot = React.createElement(TileSlot, {
				isSelected = p5 == v31,
				displayText = p4.displayText,
				thumbnail = p4.thumbnail,
				isLoading = p4.isLoading,
				isDisabled = p4.isDisabled,
				index = p5,
				onActivated = v33
			})
		})
	end)

	table.insert(v38, (React.createElement("UIListLayout", {
		key = "Layout",
		VerticalAlignment = Enum.VerticalAlignment.Center,
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 12)
	})))

	return React.createElement(not v25 and "ScrollingFrame" or Focusable.ScrollingFrame, {
		Size = UDim2.fromOffset(v29, 72),
		CanvasSize = UDim2.new(0, v34, 0, 72),
		BackgroundTransparency = 1,
		ScrollBarImageColor3 = Theme.PlaceHolder.Color,
		ScrollBarImageTransparency = Theme.PlaceHolder.Transparency,
		ScrollBarThickness = 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ref = u28,
		[React.Event.InputBegan] = t2.onInputBegan,
		[React.Event.InputEnded] = t2.onInputEnded,
		onFocusChanged = if not v25 then nil else t2.onFocusChanged,
		inputBindings = if not v25 then nil else t2.inputBindings,
		NextSelectionDown = t2.NextSelectionDown,
		NextSelectionUp = t2.NextSelectionUp,
		NextSelectionLeft = t2.NextSelectionLeft,
		NextSelectionRight = t2.NextSelectionRight,
		defaultChild = if not v25 then nil else v27[1],
		restorePreviousChildFocus = not not v25 or nil
	}, {
		SlotContainer = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = if not t2.darken then Theme.PlaceHolder.Color else Theme.Overlay.Color,
			BackgroundTransparency = if not t2.darken then Theme.PlaceHolder.Transparency else Theme.Overlay.Transparency
		}, v38)
	})
end

return SlotTray
