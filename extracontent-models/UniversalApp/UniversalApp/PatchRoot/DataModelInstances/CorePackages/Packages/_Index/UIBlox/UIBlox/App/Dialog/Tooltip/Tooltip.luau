local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local withStyle = require(parent2.Core.Style.withStyle)

local TooltipContainer = require(parent.TooltipContainer)

local TooltipOrientation = require(parent.Enum.TooltipOrientation)

local extended = Roact.PureComponent:extend("Tooltip")

extended.validateProps = t.strictInterface({
	triggerPosition = t.Vector2,
	triggerSize = t.Vector2,
	bodyText = t.string,
	headerText = t.optional(t.string),
	backgroundColor = t.optional(t.Color3),
	backgroundTransparency = t.optional(t.number),
	onDismiss = t.optional(t.callback),
	onClose = t.optional(t.callback),
	screenSize = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	orientation = t.optional(TooltipOrientation.isEnumValue),
	triggerOnHover = t.optional(t.boolean),
	forceClickTriggerPoint = t.optional(t.boolean),
	isDirectChild = t.optional(t.boolean),
	minContentWidth = t.optional(t.number)
})

extended.defaultProps = {
	screenSize = Vector2.new(10000, 10000),
	orientation = TooltipOrientation.Bottom,
	triggerOnHover = false,
	forceClickTriggerPoint = false,
	isDirectChild = false
}

function extended:init()
	function self.onDismissDefault()
		if self.props.forceClickTriggerPoint or self.props.triggerOnHover then
			return
		end

		if self.props.onDismiss then
			self.props.onDismiss()
		end
	end
end

function extended.render(p)
	local forceClickTriggerPoint = p.props.forceClickTriggerPoint or p.props.triggerOnHover
	local isDirectChild = p.props.isDirectChild
	return withStyle(function(p2)
		local theme = p2.Theme

		local background = not p.props.forceClickTriggerPoint

		if background then
			background = Roact.createElement("TextButton", {
				ZIndex = 0,
				AutoButtonColor = false,
				BackgroundColor3 = theme.Overlay.Color,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = isDirectChild and UDim2.fromOffset(-p.props.triggerPosition.X, -p.props.triggerPosition.Y) or UDim2.fromOffset(0, 0),
				Size = UDim2.fromOffset(p.props.screenSize.X, p.props.screenSize.Y),
				Text = "",
				[Roact.Event.Activated] = p.onDismissDefault,
				[Roact.Event.TouchSwipe] = p.onDismissDefault,
				[Roact.Event.MouseWheelForward] = p.onDismissDefault,
				[Roact.Event.MouseWheelBackward] = p.onDismissDefault
			})
		end

		local triggerPointMask = forceClickTriggerPoint

		if triggerPointMask then
			triggerPointMask = Roact.createElement("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Selectable = false,
				Size = UDim2.fromOffset(p.props.triggerSize.X, p.props.triggerSize.Y),
				Position = isDirectChild and UDim2.fromOffset(0, 0) or UDim2.fromOffset(
					p.props.triggerPosition.X,
					p.props.triggerPosition.Y
				),
				[Roact.Event.Activated] = p.props.onDismiss
			})
		end

		local v = {
			Background = background,
			TriggerPointMask = triggerPointMask,
			TooltipContainer = Roact.createElement(TooltipContainer, {
				triggerPosition = p.props.triggerPosition,
				triggerSize = p.props.triggerSize,
				bodyText = p.props.bodyText,
				headerText = p.props.headerText,
				screenSize = p.props.screenSize,
				position = p.props.position,
				orientation = p.props.orientation,
				isDirectChild = isDirectChild
			})
		}

		return isDirectChild
			and Roact.createElement(
				"Frame",
				{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0 },
				v
			)
			or Roact.createFragment(v)
	end)
end

return extended
