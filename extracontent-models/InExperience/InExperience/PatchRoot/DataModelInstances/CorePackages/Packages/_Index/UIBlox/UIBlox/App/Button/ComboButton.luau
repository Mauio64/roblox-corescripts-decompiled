local parent = script.Parent.Parent
local parent2 = parent.Parent
local core = parent2.Core
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local React = require(parent3.React)
local t = require(parent3.t)
local Cryo = require(parent3.Cryo)

local Images = require(parent.ImageSet.Images)
local useCursor = require(parent.SelectionCursor.useCursor)

local ControlState = require(core.Control.Enum.ControlState)
local GenericButton = require(core.Button.GenericButton)
local validateImage = require(core.ImageSet.Validator.validateImage)
local withStyle = require(core.Style.withStyle)

local extended = Roact.PureComponent:extend("ComboButton")

local udim = UDim.new(0, 8)

local buttonStateColorMap = {
	[ControlState.Default] = "ContextualPrimaryDefault",
	[ControlState.Hover] = "ContextualPrimaryOnHover"
}

local contentStateColorMap = { [ControlState.Default] = "ContextualPrimaryContent" }

extended.validateProps = t.strictInterface({
	button = t.strictInterface({
		icon = t.optional(validateImage),
		text = t.optional(t.string),
		isDisabled = t.optional(t.boolean),
		onActivated = t.callback
	}),
	overflow = t.strictInterface({
		icon = t.optional(validateImage),
		isDisabled = t.optional(t.boolean),
		onActivated = t.callback
	}),
	position = t.optional(t.UDim2),
	size = t.optional(t.UDim2),
	layoutOrder = t.optional(t.number),
	cursor = t.optional(t.table),
	testId = t.optional(t.string)
})

extended.defaultProps = { size = UDim2.fromScale(1, 1), testId = "--uiblox-combo-button" }

function extended:init()
	self:setState({
		buttonControlState = ControlState.Initialize,
		overflowControlState = ControlState.Initialize
	})

	function self.onButtonStateChanged(_, buttonControlState)
		self:setState({ buttonControlState = buttonControlState })
	end

	function self.onOverflowStateChanged(_, overflowControlState)
		self:setState({ overflowControlState = overflowControlState })
	end
end

function extended:render()
	return withStyle(function(p)
		return self:renderWithProviders(p, nil, nil)
	end)
end

function extended:renderWithProviders(_, _, _)
	local size = self.props.size
	local udim2 = UDim2.new(1, -40, 1, 0)
	local udim3 = UDim2.new(0, 39, 1, 0)

	local createElement = Roact.createElement
	local v = {
		["LayoutOrder"] = nil,
		LayoutOrder = self.props.layoutOrder,
		Position = self.props.position,
		Size = size,
		BackgroundTransparency = 1
	}

	local tag = React.Tag
	local v2

	if self.props.testId then
		v2 = `data-testid={self.props.testId}`
	end

	v[tag] = v2
	return createElement("Frame", v, {
		Button = Roact.createElement(GenericButton, {
			Position = UDim2.fromScale(0, 0),
			Size = udim2,
			buttonImage = Images["component_assets/bulletLeft_17"],
			buttonStateColorMap = buttonStateColorMap,
			contentStateColorMap = contentStateColorMap,
			hoverImage = Images["component_assets/bulletLeft_17"],
			icon = self.props.button.icon,
			isDisabled = self.props.button.isDisabled,
			isHoverBackgroundEnabled = true,
			onActivated = self.props.button.onActivated,
			onStateChanged = self.onButtonStateChanged,
			SelectionImageObject = self.props.cursor,
			text = self.props.button.text,
			ZIndex = 0
		}),
		Overflow = Roact.createElement(GenericButton, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = udim3,
			ZIndex = 0,
			buttonImage = Images["component_assets/bulletRight_17"],
			buttonStateColorMap = buttonStateColorMap,
			contentStateColorMap = contentStateColorMap,
			hoverImage = Images["component_assets/bulletRight_17"],
			icon = self.props.overflow.icon or Images["icons/actions/truncationExpand"],
			isDisabled = self.props.overflow.isDisabled,
			isHoverBackgroundEnabled = true,
			onActivated = self.props.overflow.onActivated,
			onStateChanged = self.onOverflowStateChanged,
			SelectionImageObject = self.props.cursor
		})
	})
end

function ComboButtonFunctionalWrapper(p)
	local cursor = useCursor(udim)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { cursor = cursor }))
end

local extended2 = Roact.PureComponent:extend("ComboButtonOuterWrapper")

extended2.validateProps = extended.validateProps

function extended2.render(p)
	return Roact.createElement(ComboButtonFunctionalWrapper, p.props)
end

return extended2
