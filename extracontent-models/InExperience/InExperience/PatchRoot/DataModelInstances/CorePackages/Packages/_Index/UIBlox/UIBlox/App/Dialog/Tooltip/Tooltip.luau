local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local withStyle = require(ParentParent.Core.Style.withStyle)
local TooltipContainer = require(scriptParent.TooltipContainer)
local TooltipOrientation = require(scriptParent.Enum.TooltipOrientation)
local v9 = Roact.PureComponent:extend("Tooltip")

v9.validateProps = t.strictInterface({
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
v9.defaultProps = {
	triggerOnHover = false,
	forceClickTriggerPoint = false,
	isDirectChild = false,
	screenSize = Vector2.new(10000, 10000),
	orientation = TooltipOrientation.Bottom
}

function v9.init(p1) -- line: 67
	function p1.onDismissDefault() -- line: 68
		-- upvalues: p1 (copy)
		if p1.props.forceClickTriggerPoint or p1.props.triggerOnHover then
			return
		end

		if p1.props.onDismiss then
			p1.props.onDismiss()
		end
	end
end
function v9.render(p2) -- line: 78
	-- upvalues: withStyle (copy), Roact (copy), TooltipContainer (copy)
	local v12 = p2.props.forceClickTriggerPoint or p2.props.triggerOnHover
	local isDirectChild = p2.props.isDirectChild

	return withStyle(function(p3) -- line: 81
		-- upvalues: p2 (copy), Roact (copy), isDirectChild (copy), v12 (copy), TooltipContainer (copy)
		local Theme = p3.Theme
		local t1 = {
			Background = not p2.props.forceClickTriggerPoint and Roact.createElement("TextButton", {
				ZIndex = 0,
				AutoButtonColor = false,
				BackgroundColor3 = Theme.Overlay.Color,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = isDirectChild and UDim2.fromOffset(-p2.props.triggerPosition.X, -p2.props.triggerPosition.Y) or UDim2.fromOffset(0, 0),
				Size = UDim2.fromOffset(p2.props.screenSize.X, p2.props.screenSize.Y),
				Text = "",
				[Roact.Event.Activated] = p2.onDismissDefault,
				[Roact.Event.TouchSwipe] = p2.onDismissDefault,
				[Roact.Event.MouseWheelForward] = p2.onDismissDefault,
				[Roact.Event.MouseWheelBackward] = p2.onDismissDefault
			}),
			TriggerPointMask = v12 and Roact.createElement("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Selectable = false,
				Size = UDim2.fromOffset(p2.props.triggerSize.X, p2.props.triggerSize.Y),
				Position = isDirectChild and UDim2.fromOffset(0, 0) or UDim2.fromOffset(p2.props.triggerPosition.X, p2.props.triggerPosition.Y),
				[Roact.Event.Activated] = p2.props.onDismiss
			}),
			TooltipContainer = Roact.createElement(TooltipContainer, {
				triggerPosition = p2.props.triggerPosition,
				triggerSize = p2.props.triggerSize,
				bodyText = p2.props.bodyText,
				headerText = p2.props.headerText,
				screenSize = p2.props.screenSize,
				position = p2.props.position,
				orientation = p2.props.orientation,
				isDirectChild = isDirectChild
			})
		}

		return isDirectChild and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1)
		}, t1) or Roact.createFragment(t1)
	end)
end

return v9
