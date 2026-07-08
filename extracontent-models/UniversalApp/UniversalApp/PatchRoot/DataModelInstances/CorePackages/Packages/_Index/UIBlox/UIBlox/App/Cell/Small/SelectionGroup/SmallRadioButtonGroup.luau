local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local Cryo = require(ParentParentParentParent.Cryo)
local RoactGamepad = require(ParentParentParentParent.RoactGamepad)
local t = require(ParentParentParentParent.t)
local CursorType = require(ParentParent.SelectionCursor.CursorType)
local useCursorByType = require(ParentParent.SelectionCursor.useCursorByType)
local SmallRadioButtonCell = require(ParentParentParent.App.Cell.Small.SelectionGroup.SmallRadioButtonCell)
local v11 = Roact.PureComponent:extend("SmallRadioButtonGroup")
local v12 = t.strictInterface({
	text = t.string,
	id = t.string,
	isDisabled = t.optional(t.boolean)
})

v11.validateProps = t.strictInterface({
	items = t.optional(t.array(t.tuple(v12))),
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
v11.defaultProps = {
	selectedValue = nil,
	isRoactGamepadEnabled = true
}

function v11.init(p1) -- line: 65
	-- upvalues: RoactGamepad (copy)
	p1.gamepadRefs = p1.props.isRoactGamepadEnabled and RoactGamepad.createRefCache() or {}
end
function v11.renderButtonCell(p2, p3, p4, p5) -- line: 69
	-- upvalues: Roact (copy), RoactGamepad (copy), SmallRadioButtonCell (copy)
	return Roact.createElement(if not p5 then SmallRadioButtonCell else RoactGamepad.Focusable[SmallRadioButtonCell], {
		id = p3.id,
		text = p3.text,
		onActivated = p2.props.onActivated,
		isSelected = p2.props.selectedValue == p3.id,
		isDisabled = p3.isDisabled,
		layoutOrder = p4,
		useDefaultControlState = p2.props.useDefaultControlState,
		[Roact.Ref] = p2.gamepadRefs[p4],
		NextSelectionUp = p4 > 1 and p2.gamepadRefs[p4 - 1] or nil,
		NextSelectionDown = p4 < #p2.props.items and p2.gamepadRefs[p4 + 1] or nil,
		SelectionImageObject = p2.props.cursor
	})
end
function v11.render(p6) -- line: 89
	-- upvalues: Roact (copy), RoactGamepad (copy)
	assert(p6.validateProps(p6.props))

	local t1 = {
		layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 1)
		})
	}
	local isRoactGamepadEnabled = p6.props.isRoactGamepadEnabled

	for i, v in ipairs(p6.props.items) do
		if not isRoactGamepadEnabled then
			p6.gamepadRefs[i] = p6.gamepadRefs[i] or Roact.createRef()
		end

		t1["smallRadioButtonCell" .. v.id] = p6:renderButtonCell(v, i, isRoactGamepadEnabled)
	end

	local v23 = isRoactGamepadEnabled and (p6.props.items and #p6.props.items > 0)

	return Roact.createElement(not v23 and "Frame" or RoactGamepad.Focusable.Frame, {
		defaultChild = if not v23 then nil else p6.gamepadRefs[1],
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = p6.props.layoutOrder,
		NextSelectionLeft = p6.props.NextSelectionLeft,
		NextSelectionRight = p6.props.NextSelectionRight,
		NextSelectionDown = p6.props.NextSelectionDown,
		NextSelectionUp = p6.props.NextSelectionUp,
		[Roact.Ref] = p6.props.frameRef
	}, t1)
end

return Roact.forwardRef(function(p7, p8) -- line: 121
	-- upvalues: useCursorByType (copy), CursorType (copy), Roact (copy), v11 (copy), Cryo (copy)
	local v26 = useCursorByType(CursorType.SelectionCell)

	return Roact.createElement(v11, Cryo.Dictionary.join(p7, {
		frameRef = p8,
		cursor = v26
	}))
end)
