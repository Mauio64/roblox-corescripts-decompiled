local ParentParent = script.Parent.Parent.Parent.Parent
local UIBlox = ParentParent.UIBlox
local Roact = require(ParentParent.Roact)
local RoactGamepad = require(ParentParent.RoactGamepad)
local t = require(ParentParent.t)
local RadioButton = require(script.Parent.RadioButton)
local Cryo = require(ParentParent.Cryo)
local useCursorByType = require(UIBlox.App.SelectionCursor.useCursorByType)
local CursorType = require(UIBlox.App.SelectionCursor.CursorType)
local v10 = Roact.PureComponent:extend("RadioButtonList")
local v11 = t.strictInterface({
	label = t.string,
	isDisabled = t.optional(t.boolean)
})

v10.validateProps = t.strictInterface({
	radioButtons = t.array(t.union(t.string, v11)),
	onActivated = t.callback,
	elementSize = t.UDim2,
	initialValue = t.optional(t.number),
	currentValue = t.optional(t.number),
	layoutOrder = t.optional(t.number),
	padding = t.optional(t.UDim),
	automaticSize = t.optional(t.boolean),
	cursor = t.table,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	forwardRef = t.optional(t.table),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v10.defaultProps = {
	isRoactGamepadEnabled = true
}

function v10.init(p1) -- line: 57
	-- upvalues: RoactGamepad (copy)
	p1.state = {
		currentValue = p1.props.initialValue or 0
	}

	local t1 = {}

	for i, v in ipairs(p1.props.radioButtons) do
		t1[i] = type(v) == "table" and (v.isDisabled or false)
	end

	p1.state.disabledIndices = t1

	function p1.doLogic(p2) -- line: 68
		-- upvalues: p1 (copy)
		if p1.state.disabledIndices[p2] then
			return
		end

		p1:setState({
			currentValue = p2
		})
		p1.props.onActivated(p2)
	end

	p1.gamepadRefs = p1.props.isRoactGamepadEnabled and RoactGamepad.createRefCache() or {}
end
function v10.renderWithProviders(p3, _, p5) -- line: 81
	-- upvalues: Roact (copy), RoactGamepad (copy), RadioButton (copy)
	local t2 = {
		layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = p3.props.padding
		})
	}

	for i, v in ipairs(p3.props.radioButtons) do
		if not p3.props.isRoactGamepadEnabled then
			p3.gamepadRefs[i] = p3.gamepadRefs[i] or Roact.createRef()
		end

		t2["RadioButton" .. i] = Roact.createElement(if not p3.props.isRoactGamepadEnabled then RadioButton else RoactGamepad.Focusable[RadioButton], {
			text = type(v) == "table" and v.label or v,
			isSelected = if p3.props.currentValue == nil then i == p3.state.currentValue else i == p3.props.currentValue,
			isDisabled = p3.state.disabledIndices[i],
			onActivated = p3.doLogic,
			size = p3.props.elementSize,
			layoutOrder = i,
			id = i,
			isRoactGamepadEnabled = p3.props.isRoactGamepadEnabled,
			[Roact.Ref] = p3.gamepadRefs[i],
			NextSelectionUp = i > 1 and p3.gamepadRefs[i - 1] or nil,
			NextSelectionDown = i < #p3.props.radioButtons and p3.gamepadRefs[i + 1] or nil,
			SelectionImageObject = p5,
			inputBindings = if not p3.props.isRoactGamepadEnabled then nil else {
				OnActivatedButton = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 112
					-- upvalues: p3 (copy), i (copy)
					p3.doLogic(i)
				end)
			}
		})
	end

	return Roact.createElement(not p3.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame, {
		Size = if not p3.props.automaticSize then UDim2.fromScale(1, 1) else UDim2.fromScale(1, 0),
		AutomaticSize = if not p3.props.automaticSize then nil else Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = p3.props.layoutOrder,
		[Roact.Ref] = p3.props.forwardRef,
		NextSelectionLeft = p3.props.NextSelectionLeft,
		NextSelectionRight = p3.props.NextSelectionRight,
		NextSelectionDown = p3.props.NextSelectionDown,
		NextSelectionUp = p3.props.NextSelectionUp
	}, t2)
end
function v10.render(p6) -- line: 134
	return p6:renderWithProviders(nil, p6.props.cursor)
end

return Roact.forwardRef(function(p7, p8) -- line: 138
	-- upvalues: useCursorByType (copy), CursorType (copy), Roact (copy), v10 (copy), Cryo (copy)
	local v25 = useCursorByType(CursorType.RoundedRect)

	return Roact.createElement(v10, Cryo.Dictionary.join(p7, {
		forwardRef = p8,
		cursor = v25
	}))
end)
