local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)

local Images = require(parent.App.ImageSet.Images)
local EmptyState = require(parent.App.Indicator.EmptyState)
local Button = require(parent.App.Button.Button)
local ButtonType = require(parent.App.Button.Enum.ButtonType)

local RenderOnFailedStyle = require(parent.App.Loading.Enum.RenderOnFailedStyle)

local extended = Roact.PureComponent:extend("FailedStatePage")

extended.validateProps = t.strictInterface({
	onRetry = t.optional(t.callback),
	renderOnFailed = t.optional(RenderOnFailedStyle.isEnumValue),
	text = t.optional(t.string)
})

extended.defaultProps = { renderOnFailed = RenderOnFailedStyle.RetryButton }

function extended.render(p)
	if p.props.renderOnFailed == RenderOnFailedStyle.EmptyStatePage then
		return Roact.createElement(EmptyState, {
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			onActivated = p.props.onRetry,
			icon = Images["icons/status/noconnection_large"],
			text = p.props.text
		})
	end

	if p.props.renderOnFailed ~= RenderOnFailedStyle.RetryButton then
		error("Failed to provide proper RenderOnFailedStyle")

		return
	end

	if p.props.onRetry then
		return Roact.createElement(Button, {
			buttonType = ButtonType.Secondary,
			size = UDim2.fromOffset(44, 44),
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			onActivated = p.props.onRetry,
			icon = Images["icons/common/refresh"]
		})
	end

	error("OnRetry callback empty. OnRetry needs to be a function to render the RetryButton")
end

return extended
