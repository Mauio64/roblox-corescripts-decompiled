local parent = script.Parent.Parent.Parent.Parent
local uiBlox = parent.UIBlox

local Roact = require(parent.Roact)
local RoactGamepad = require(parent.RoactGamepad)
local t = require(parent.t)
local RadioButton = require(script.Parent.RadioButton)
local Cryo = require(parent.Cryo)

local useCursorByType = require(uiBlox.App.SelectionCursor.useCursorByType)
local CursorType = require(uiBlox.App.SelectionCursor.CursorType)

local extended = Roact.PureComponent:extend("RadioButtonList")

local strictInterface = t.strictInterface({ label = t.string, isDisabled = t.optional(t.boolean) })

extended.validateProps = t.strictInterface({
	radioButtons = t.array(t.union(t.string, strictInterface)),
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

extended.defaultProps = { isRoactGamepadEnabled = true }

function extended:init()
	self.state = {
		currentValue = self.props.initialValue or 0
	}

	local disabledIndices = {}

	for i, radioButton in ipairs(self.props.radioButtons) do
		disabledIndices[i] = type(radioButton) == "table" and (radioButton.isDisabled or false)
	end

	self.state.disabledIndices = disabledIndices

	function self.doLogic(currentValue)
		if self.state.disabledIndices[currentValue] then
			return
		end

		self:setState({ currentValue = currentValue })

		self.props.onActivated(currentValue)
	end

	self.gamepadRefs = self.props.isRoactGamepadEnabled and RoactGamepad.createRefCache() or {}
end

function extended:renderWithProviders(_, selectionImageObject)
	local children = {
		layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = self.props.padding
		})
	}

	for i, label in ipairs(self.props.radioButtons) do
		if not self.props.isRoactGamepadEnabled then
			self.gamepadRefs[i] = self.gamepadRefs[i] or Roact.createRef()
		end

		local v = "RadioButton" .. i
		local createElement = Roact.createElement
		local v2

		if self.props.isRoactGamepadEnabled then
			v2 = RoactGamepad.Focusable[RadioButton]
		else
			v2 = RadioButton
		end

		label = type(label) == "table" and label.label or label
		local isSelected

		if self.props.currentValue == nil then
			isSelected = i == self.state.currentValue
		else
			isSelected = i == self.props.currentValue
		end

		local v3 = {
			text = label,
			isSelected = isSelected,
			isDisabled = self.state.disabledIndices[i],
			onActivated = self.doLogic,
			size = self.props.elementSize,
			layoutOrder = i,
			id = i,
			isRoactGamepadEnabled = self.props.isRoactGamepadEnabled,
			[Roact.Ref] = self.gamepadRefs[i]
		}
		local nextSelectionUp

		if i > 1 then
			nextSelectionUp = self.gamepadRefs[i - 1] or nil
		end

		v3.NextSelectionUp = nextSelectionUp
		local nextSelectionDown

		if i < #self.props.radioButtons then
			nextSelectionDown = self.gamepadRefs[i + 1] or nil
		end

		v3.NextSelectionDown = nextSelectionDown
		v3.SelectionImageObject = selectionImageObject
		v3.inputBindings = self.props.isRoactGamepadEnabled and {
			OnActivatedButton = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function()
				self.doLogic(i)
			end)
		} or nil
		children[v] = createElement(v2, v3)
	end

	local createElement = Roact.createElement
	local v = not self.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame
	local size

	if self.props.automaticSize then
		size = UDim2.fromScale(1, 0)
	else
		size = UDim2.fromScale(1, 1)
	end

	local automaticSize

	if self.props.automaticSize then
		automaticSize = Enum.AutomaticSize.Y
	end

	return createElement(v, {
		Size = size,
		AutomaticSize = automaticSize,
		BackgroundTransparency = 1,
		LayoutOrder = self.props.layoutOrder,
		[Roact.Ref] = self.props.forwardRef,
		NextSelectionLeft = self.props.NextSelectionLeft,
		NextSelectionRight = self.props.NextSelectionRight,
		NextSelectionDown = self.props.NextSelectionDown,
		NextSelectionUp = self.props.NextSelectionUp
	}, children)
end

function extended:render()
	return self:renderWithProviders(nil, self.props.cursor)
end

return Roact.forwardRef(function(p, forwardRef)
	local cursor = useCursorByType(CursorType.RoundedRect)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, {
		forwardRef = forwardRef,
		cursor = cursor
	}))
end)
