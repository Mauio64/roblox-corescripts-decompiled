local parent = script.Parent.Parent
local parent2 = parent.Parent
local core = parent2.Core
local parent3 = parent2.Parent

local Cryo = require(parent3.Cryo)
local t = require(parent3.t)
local Roact = require(parent3.Roact)
local enumerate = require(parent3.enumerate)
local bindingValidator = require(core.Utility.bindingValidator)

local withStyle = require(core.Style.withStyle)
local withSelectionCursorProvider = require(parent.SelectionImage.withSelectionCursorProvider)
local useCursorByType = require(parent.SelectionCursor.useCursorByType)
local Interactable = require(core.Control.Interactable)
local ControlState = require(core.Control.Enum.ControlState)
local CursorType = require(parent.SelectionCursor.CursorType)

local extended = Roact.PureComponent:extend("Cell")
extended.debugProps = enumerate("debugProps", { "controlState" })

extended.validateProps = t.strictInterface({
	head = t.table,
	tail = t.optional(t.table),
	background = t.optional(t.table),
	layoutOrder = t.optional(t.union(t.integer, bindingValidator(t.number))),
	size = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	horizontalPadding = t.optional(t.number),
	selectable = t.optional(t.boolean),
	layoutWraps = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	userInteractionEnabled = t.optional(t.boolean),
	onStateChanged = t.optional(t.callback),
	onActivated = t.optional(t.callback),
	onTouchTapped = t.optional(t.callback),
	[extended.debugProps.controlState] = t.optional(ControlState.isEnumValue),
	[Roact.Change.AbsolutePosition] = t.optional(t.callback),
	[Roact.Ref] = t.optional(t.union(t.callback, t.table)),
	forwardRef = t.optional(t.union(t.callback, t.table)),
	selectionCursor = t.optional(t.any)
})

extended.defaultProps = {
	isDisabled = false,
	userInteractionEnabled = true,
	horizontalPadding = 24
}

function extended:init()
	self:setState({ controlState = ControlState.Initialize })

	self.stateStyleMap = {
		[ControlState.Default] = "BackgroundDefault",
		[ControlState.Hover] = "BackgroundOnHover",
		[ControlState.Pressed] = "BackgroundOnPress"
	}

	function self.getBackgroundStyle(p, p2)
		local v = self.stateStyleMap[p] or self.stateStyleMap[ControlState.Default]

		local v2 = { Color = p2.Theme[v].Color, Transparency = p2.Theme[v].Transparency }

		if p == ControlState.Disabled then
			v2.Transparency = 1
		end

		return v2
	end

	function self.onStateChanged(p, controlState)
		self:setState({ controlState = controlState })

		if self.props.onStateChanged then
			self.props.onStateChanged(p, controlState)
		end
	end
end

function extended:render()
	return withStyle(function(p)
		return withSelectionCursorProvider(function(p2)
			return self:renderWithProviders(p, p2)
		end)
	end)
end

function extended:renderWithProviders(p, _)
	local anchorPoint = self.props.anchorPoint
	local layoutOrder = self.props.layoutOrder
	local position = self.props.position
	local size = self.props.size or UDim2.fromScale(1, 1)

	local head = self.props.head
	local tail = self.props.tail
	local background = self.props.background

	local isDisabled = self.props.isDisabled
	local fn = self.props.onActivated and function(...)
		if self.props.tail and self.props.userInteractionEnabled and self.props.onActivated then
			self.props.onActivated(...)
		end
	end or self.props.onActivated
	local onTouchTapped = self.props.onTouchTapped

	local v = self.props[extended.debugProps.controlState] or self.state.controlState
	local backgroundStyle = self.getBackgroundStyle(v, p)

	return Roact.createElement(Interactable, {
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		Position = position,
		Size = size,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Selectable = self.props.selectable,
		SelectionImageObject = self.props.selectionCursor,
		isDisabled = isDisabled,
		onStateChanged = self.onStateChanged,
		[Roact.Event.Activated] = fn,
		[Roact.Event.TouchTap] = onTouchTapped,
		[Roact.Change.AbsolutePosition] = self.props[Roact.Change.AbsolutePosition],
		[Roact.Ref] = self.props.forwardRef
	}, {
		CellBackground = Roact.createElement(
			"Frame",
			{
				Size = size,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ZIndex = -1
			},
			{
				Background = background or Roact.createElement("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = backgroundStyle.Color,
					BackgroundTransparency = backgroundStyle.Transparency,
					BorderSizePixel = 0
				}),
				CellContent = Roact.createElement("Frame", {
					Size = UDim2.fromScale(1, 1),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 2
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
						Wraps = self.props.layoutWraps
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, self.props.horizontalPadding),
						PaddingRight = UDim.new(0, self.props.horizontalPadding)
					}),
					CellHead = Roact.createElement("Frame", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.XY,
						LayoutOrder = 1
					}, { Head = head }),
					CellTail = tail and Roact.createElement("Frame", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.fromScale(1, 0.5),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.XY,
						LayoutOrder = 2
					}, { Tail = tail }) or nil
				})
			}
		),
		DisabledMask = v == ControlState.Disabled and Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = backgroundStyle.Color,
			BackgroundTransparency = 0.5,
			ZIndex = 100
		}) or nil
	})
end

return Roact.forwardRef(function(p, forwardRef)
	local selectionCursor = useCursorByType(CursorType.RoundedRectNoInset)
	local joined = Cryo.Dictionary.join({ selectionCursor = selectionCursor }, p)

	return Roact.createElement(extended, Cryo.Dictionary.join(joined, { forwardRef = forwardRef }))
end)
