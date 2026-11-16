local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local core = parent2.Core

local React = require(parent3.React)
local t = require(parent3.t)
local Otter = require(parent3.Otter)
local Cryo = require(parent3.Cryo)

local RoactGamepad = require(parent3.RoactGamepad)
local Focusable = RoactGamepad.Focusable

local TileSlot = require(script.Parent.TileSlot)
local useStyle = require(core.Style.useStyle)
local CursorKind = require(parent.SelectionImage.CursorKind)
local useSelectionCursor = require(parent.SelectionImage.useSelectionCursor)

local v = { dampingRatio = 1, frequency = 10 }

local strictInterface = t.strictInterface({
	displayText = t.optional(t.string),
	thumbnail = t.optional(t.string),
	isDisabled = t.optional(t.boolean),
	isLoading = t.optional(t.boolean)
})

local strictInterface2 = t.strictInterface({
	slots = t.array(strictInterface),
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

local function useScrollingFrameMotor(p, value: number?)
	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = Otter.createSingleMotor(value or 0)
	end

	local current = ref.current
	React.useEffect(function()
		current:onStep(function(p2)
			if p.current ~= nil then
				p.current.CanvasPosition = Vector2.new(p2, 0)
			end
		end)

		return function()
			current:destroy()
		end
	end, {})

	return current
end

local function SlotTray(props)
	local v2 = props.isRoactGamepadEnabled == nil or props.isRoactGamepadEnabled
	local ref = React.useRef({})
	local v3

	if v2 then
		v3 = RoactGamepad.useRefCache()
	else
		v3 = ref.current
	end

	local ref2 = React.useRef(nil)

	if props.scrollingFrameRef then
		ref2 = props.scrollingFrameRef
	end

	local width = props.width or 360

	local v4 = useScrollingFrameMotor(ref2, 0)

	local state, setState = React.useState(props.defaultSelectedSlotIndex or 1)

	React.useEffect(function()
		local current = ref2.current

		if state == 0 or not current then
			return
		end

		local current2 = v3[state] and v3[state].current

		if not current2 then
			return
		end

		local x = current.CanvasPosition.X
		local x2 = current.AbsolutePosition.X
		local v5 = x2 + width

		local x3 = current2.AbsolutePosition.X
		local v6 = x3 + 48 + 24 - v5
		local v7 = x3 - 24 - x2

		local v8 = x + v6
		local v9 = x + v7

		if x < v8 then
			v4:setGoal(Otter.spring(v8, v))
		elseif v9 < x then
			v4:setGoal(Otter.spring(v9, v))
		end
	end, { state, width, v3, ref2, v4 })

	local onActivated = React.useCallback(function(p)
		setState(p)
		props.onChange(p)
	end, { props.onChange })

	local v5 = #props.slots * 48 + (#props.slots - 1) * 12 + 48

	local v6 = useStyle()
	local selectionImageObject = useSelectionCursor(CursorKind.RoundedSlot)

	assert(strictInterface2(props))
	local theme = v6.Theme

	local mapped = Cryo.List.map(props.slots, function(props2, layoutOrder)
		if not v2 then
			v3[layoutOrder] = v3[layoutOrder] or React.createRef()
		end

		local createElement = React.createElement
		local v7 = not v2 and "Frame" or Focusable.Frame
		local v8 = {
			key = "Slot" .. tostring(layoutOrder),
			LayoutOrder = layoutOrder,
			Size = UDim2.fromOffset(48, 48),
			BackgroundTransparency = 1,
			BorderSizePixel = 2,
			ref = v3[layoutOrder],
			NextSelectionRight = 0,
			NextSelectionLeft = 0,
			onFocusGained = 0,
			SelectionImageObject = 0
		}
		local nextSelectionRight

		if layoutOrder < #props.slots then
			nextSelectionRight = v3[layoutOrder + 1] or nil
		end

		v8.NextSelectionRight = nextSelectionRight
		local nextSelectionLeft

		if layoutOrder > 1 then
			nextSelectionLeft = v3[layoutOrder - 1] or nil
		end

		v8.NextSelectionLeft = nextSelectionLeft
		v8.onFocusGained = v2 and function()
			onActivated(layoutOrder)
		end or nil

		v8.SelectionImageObject = selectionImageObject
		return createElement(v7, v8, {
			Slot = React.createElement(TileSlot, {
				isSelected = state == layoutOrder,
				displayText = props2.displayText,
				thumbnail = props2.thumbnail,
				isLoading = props2.isLoading,
				isDisabled = props2.isDisabled,
				index = layoutOrder,
				onActivated = onActivated
			})
		})
	end)

	table.insert(mapped, (React.createElement("UIListLayout", {
		key = "Layout",
		VerticalAlignment = Enum.VerticalAlignment.Center,
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 12)
	})))

	local createElement = React.createElement
	local v7 = not v2 and "ScrollingFrame" or Focusable.ScrollingFrame
	local v8 = {
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		Size = UDim2.fromOffset(width, 72),
		CanvasSize = UDim2.new(0, v5, 0, 72),
		BackgroundTransparency = 1,
		ScrollBarImageColor3 = theme.PlaceHolder.Color,
		ScrollBarImageTransparency = theme.PlaceHolder.Transparency,
		ScrollBarThickness = 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ref = ref2,
		[React.Event.InputBegan] = props.onInputBegan,
		[React.Event.InputEnded] = props.onInputEnded
	}
	local onFocusChanged

	if v2 then
		onFocusChanged = props.onFocusChanged
	end

	v8.onFocusChanged = onFocusChanged
	local inputBindings

	if v2 then
		inputBindings = props.inputBindings
	end

	v8.inputBindings = inputBindings
	v8.NextSelectionDown = props.NextSelectionDown
	v8.NextSelectionUp = props.NextSelectionUp
	v8.NextSelectionLeft = props.NextSelectionLeft
	v8.NextSelectionRight = props.NextSelectionRight
	local defaultChild

	if v2 then
		defaultChild = v3[1]
	end

	v8.defaultChild = defaultChild
	v8.restorePreviousChildFocus = v2 and true or nil

	local createElement2 = React.createElement
	local v9 = { Size = UDim2.fromScale(1, 1), BackgroundColor3 = 0, BackgroundTransparency = 0 }
	local backgroundColor

	if props.darken then
		backgroundColor = theme.Overlay.Color
	else
		backgroundColor = theme.PlaceHolder.Color
	end

	v9.BackgroundColor3 = backgroundColor
	local backgroundTransparency

	if props.darken then
		backgroundTransparency = theme.Overlay.Transparency
	else
		backgroundTransparency = theme.PlaceHolder.Transparency
	end

	v9.BackgroundTransparency = backgroundTransparency
	return createElement(v7, v8, {
		SlotContainer = createElement2("Frame", v9, mapped)
	})
end

return SlotTray
