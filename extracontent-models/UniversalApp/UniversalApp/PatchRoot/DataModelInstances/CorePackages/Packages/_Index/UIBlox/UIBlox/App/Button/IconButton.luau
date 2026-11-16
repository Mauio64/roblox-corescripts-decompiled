local App = script:FindFirstAncestor("App")
local parent = App.Parent
local core = parent.Core
local parent2 = parent.Parent

local t = require(parent2.t)
local Roact = require(parent2.Roact)
local Cryo = require(parent2.Cryo)

local Interactable = require(core.Control.Interactable)

local ControlState = require(core.Control.Enum.ControlState)
local getContentStyle = require(core.Button.getContentStyle)
local getIconSize = require(App.ImageSet.getIconSize)
local bindingValidator = require(core.Utility.bindingValidator)
local validateImage = require(core.ImageSet.Validator.validateImage)
local validateColorInfo = require(core.Style.Validator.validateColorInfo)

local withStyle = require(core.Style.withStyle)
local HoverButtonBackground = require(core.Button.HoverButtonBackground)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local IconSize = require(App.ImageSet.Enum.IconSize)

local RoactGamepad = require(parent2.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local isCallable = require(parent.Utility.isCallable)
local useCursor = require(parent.App.SelectionCursor.useCursor)

local udim = UDim.new(0, 8)

local extended = Roact.PureComponent:extend("IconButton")

extended.validateProps = t.strictInterface({
	onStateChanged = t.optional(isCallable),
	isDisabled = t.optional(t.boolean),
	colorStyleDefault = t.optional(t.string),
	colorStyleHover = t.optional(t.string),
	colorDefault = t.optional(validateColorInfo),
	colorHover = t.optional(validateColorInfo),
	userInteractionEnabled = t.optional(t.boolean),
	onActivated = t.optional(isCallable),
	onAbsolutePositionChanged = t.optional(isCallable),
	anchorPoint = t.optional(t.Vector2),
	layoutOrder = t.optional(t.number),
	position = t.optional(t.union(t.UDim2, t.table)),
	size = t.optional(t.union(t.UDim2, t.table)),
	icon = t.optional(validateImage),
	iconSize = t.optional(IconSize.isEnumValue),
	iconColor3 = t.optional(t.Color3),
	iconTransparency = t.optional(t.union(t.number, bindingValidator(t.number))),
	showBackground = t.optional(t.boolean),
	backgroundColor = t.optional(validateColorInfo),
	backgroundTransparency = t.optional(t.union(t.number, bindingValidator(t.number))),
	cursor = t.optional(t.table),
	[Roact.Children] = t.optional(t.table),
	debugControlState = t.optional(ControlState.isEnumValue),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	inputBindings = t.optional(t.table),
	buttonRef = t.optional(t.union(t.callback, t.table)),
	[Roact.Change.AbsoluteSize] = t.optional(t.callback),
	isRoactGamepadEnabled = t.optional(t.boolean)
})

extended.defaultProps = {
	anchorPoint = Vector2.new(0, 0),
	layoutOrder = 0,
	position = UDim2.new(0, 0, 0, 0),
	size = nil,
	icon = "",
	iconSize = IconSize.Medium,
	colorStyleDefault = "IconEmphasis",
	colorStyleHover = "IconEmphasis",
	iconColor3 = nil,
	iconTransparency = nil,
	showBackground = false,
	backgroundColor = nil,
	backgroundTransparency = nil,
	isDisabled = false,
	userInteractionEnabled = true,
	debugControlState = nil,
	isRoactGamepadEnabled = true
}

function extended:init()
	self:setState({ controlState = ControlState.Initialize })

	function self.onStateChanged(p, controlState)
		self:setState({ controlState = controlState })

		if self.props.onStateChanged then
			self.props.onStateChanged(p, controlState)
		end
	end

	local v = {
		[IconSize.Small] = 1,
		[IconSize.Medium] = 2,
		[IconSize.Large] = 3,
		[IconSize.XLarge] = 4,
		[IconSize.XXLarge] = 5
	}

	function self.getSize(p)
		if self.props.size then
			return self.props.size
		end

		local v2 = p + 4 * v[self.props.iconSize]
		return UDim2.fromOffset(v2, v2)
	end
end

function extended:render()
	return withStyle(function(p)
		return self:renderWithProviders(p, nil, nil)
	end)
end

function extended:renderWithProviders(p, _, _)
	local iconSize = getIconSize(self.props.iconSize, p)
	local size = self.getSize(iconSize)
	local showBackground = self.props.showBackground
	local debugControlState = self.props.debugControlState or self.state.controlState

	local contentStyle = getContentStyle(
		{
			[ControlState.Default] = self.props.colorStyleDefault,
			[ControlState.Hover] = self.props.colorStyleHover
		},
		debugControlState,
		p
	)
	local v

	if self.props.backgroundColor == nil then
		v = p.Theme.UIMuted
	else
		v = self.props.backgroundColor
	end

	local createElement = Roact.createElement
	local v2

	if self.props.isRoactGamepadEnabled then
		v2 = Focusable[Interactable]
	else
		v2 = Interactable
	end

	local v3 = {
		AnchorPoint = self.props.anchorPoint,
		LayoutOrder = self.props.layoutOrder,
		Position = self.props.position,
		Size = size,
		isDisabled = self.props.isDisabled,
		onStateChanged = self.onStateChanged,
		userInteractionEnabled = self.props.userInteractionEnabled,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		[Roact.Change.AbsoluteSize] = self.props[Roact.Change.AbsoluteSize],
		[Roact.Change.AbsolutePosition] = self.props.onAbsolutePositionChanged,
		[Roact.Event.Activated] = self.props.onActivated,
		[Roact.Ref] = self.props.buttonRef,
		NextSelectionLeft = self.props.NextSelectionLeft,
		NextSelectionRight = self.props.NextSelectionRight,
		NextSelectionUp = self.props.NextSelectionUp,
		NextSelectionDown = self.props.NextSelectionDown
	}
	local inputBindings

	if self.props.isRoactGamepadEnabled then
		inputBindings = self.props.inputBindings
	end

	v3.inputBindings = inputBindings
	v3.SelectionImageObject = self.props.cursor
	local v4 = {
		sizeConstraint = Roact.createElement("UISizeConstraint", {
			MinSize = Vector2.new(iconSize, iconSize)
		}),
		imageLabel = Roact.createElement(ImageSetComponent.Label, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(iconSize, iconSize),
			BackgroundTransparency = 1,
			Image = self.props.icon,
			ImageColor3 = self.props.iconColor3 or contentStyle.Color,
			ImageTransparency = self.props.iconTransparency or contentStyle.Transparency
		}, self.props[Roact.Children]),
		hoverBackground = debugControlState == ControlState.Hover and Roact.createElement(HoverButtonBackground) or nil,
		background = 0
	}
	local background

	if showBackground then
		background = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v.Color,
			BackgroundTransparency = self.props.backgroundTransparency or v.Transparency,
			ZIndex = 0
		}, {
			corner = Roact.createElement("UICorner", { CornerRadius = udim })
		}) or nil
	end

	v4.background = background
	return createElement(v2, v3, v4)
end

local function IconButtonFunctionalWrapper(p)
	local cursor = useCursor(udim)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { cursor = cursor }))
end

local extended2 = Roact.PureComponent:extend("IconButtonOuterWrapper")

extended2.validateProps = extended.validateProps

function extended2.render(p)
	return Roact.createElement(IconButtonFunctionalWrapper, p.props)
end

return extended2
