local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local Cryo = require(parent3.Cryo)
local RoactGamepad = require(parent3.RoactGamepad)
local t = require(parent3.t)

local CursorType = require(parent.SelectionCursor.CursorType)
local useCursorByType = require(parent.SelectionCursor.useCursorByType)

local SmallRadioButtonCell = require(parent2.App.Cell.Small.SelectionGroup.SmallRadioButtonCell)

local extended = Roact.PureComponent:extend("SmallRadioButtonGroup")

local strictInterface = t.strictInterface({
	text = t.string,
	id = t.string,
	isDisabled = t.optional(t.boolean)
})

extended.validateProps = t.strictInterface({
	items = t.optional(t.array(t.tuple(strictInterface))),
	selectedValue = t.optional(t.string),
	cursor = t.optional(t.table),
	onActivated = t.callback,
	layoutOrder = t.optional(t.number),
	useDefaultControlState = t.optional(t.boolean),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	frameRef = t.optional(t.table),
	isRoactGamepadEnabled = t.optional(t.boolean)
})

extended.defaultProps = { selectedValue = nil, isRoactGamepadEnabled = true }

function extended:init()
	self.gamepadRefs = self.props.isRoactGamepadEnabled and RoactGamepad.createRefCache() or {}
end

function extended:renderButtonCell(props, layoutOrder, p)
	local createElement = Roact.createElement
	local v

	if p then
		v = RoactGamepad.Focusable[SmallRadioButtonCell]
	else
		v = SmallRadioButtonCell
	end

	local v2 = {
		["id"] = nil,
		id = props.id,
		text = props.text,
		onActivated = self.props.onActivated,
		isSelected = self.props.selectedValue == props.id,
		isDisabled = props.isDisabled,
		layoutOrder = layoutOrder,
		useDefaultControlState = self.props.useDefaultControlState,
		[Roact.Ref] = self.gamepadRefs[layoutOrder]
	}
	local nextSelectionUp

	if layoutOrder > 1 then
		nextSelectionUp = self.gamepadRefs[layoutOrder - 1] or nil
	end

	v2.NextSelectionUp = nextSelectionUp
	local nextSelectionDown

	if layoutOrder < #self.props.items then
		nextSelectionDown = self.gamepadRefs[layoutOrder + 1] or nil
	end

	v2.NextSelectionDown = nextSelectionDown
	v2.SelectionImageObject = self.props.cursor
	return createElement(v, v2)
end

function extended:render()
	assert(self.validateProps(self.props))

	local v = {
		layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 1)
		})
	}

	local isRoactGamepadEnabled = self.props.isRoactGamepadEnabled

	for i, item in ipairs(self.props.items) do
		if not isRoactGamepadEnabled then
			self.gamepadRefs[i] = self.gamepadRefs[i] or Roact.createRef()
		end

		v["smallRadioButtonCell" .. item.id] = self:renderButtonCell(item, i, isRoactGamepadEnabled)
	end

	local v2 = isRoactGamepadEnabled and self.props.items and #self.props.items > 0
	local createElement = Roact.createElement
	local v3 = not v2 and "Frame" or RoactGamepad.Focusable.Frame
	local defaultChild

	if v2 then
		defaultChild = self.gamepadRefs[1]
	end

	return createElement(v3, {
		defaultChild = defaultChild,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = self.props.layoutOrder,
		NextSelectionLeft = self.props.NextSelectionLeft,
		NextSelectionRight = self.props.NextSelectionRight,
		NextSelectionDown = self.props.NextSelectionDown,
		NextSelectionUp = self.props.NextSelectionUp,
		[Roact.Ref] = self.props.frameRef
	}, v)
end

return Roact.forwardRef(function(p, frameRef)
	local cursor = useCursorByType(CursorType.SelectionCell)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, {
		frameRef = frameRef,
		cursor = cursor
	}))
end)
