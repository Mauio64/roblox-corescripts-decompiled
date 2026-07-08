local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Images = require(ParentParent.App.ImageSet.Images)
local EmptyState = require(ParentParent.App.Indicator.EmptyState)
local Button = require(ParentParent.App.Button.Button)
local ButtonType = require(ParentParent.App.Button.Enum.ButtonType)
local RenderOnFailedStyle = require(ParentParent.App.Loading.Enum.RenderOnFailedStyle)
local v10 = Roact.PureComponent:extend("FailedStatePage")

v10.validateProps = t.strictInterface({
	onRetry = t.optional(t.callback),
	renderOnFailed = t.optional(RenderOnFailedStyle.isEnumValue),
	text = t.optional(t.string)
})
v10.defaultProps = {
	renderOnFailed = RenderOnFailedStyle.RetryButton
}

function v10.render(p1) -- line: 36
	-- upvalues: RenderOnFailedStyle (copy), Roact (copy), EmptyState (copy), Images (copy), Button (copy), ButtonType (copy)
	if p1.props.renderOnFailed == RenderOnFailedStyle.EmptyStatePage then
		return Roact.createElement(EmptyState, {
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			onActivated = p1.props.onRetry,
			icon = Images["icons/status/noconnection_large"],
			text = p1.props.text
		})
	end

	if p1.props.renderOnFailed == RenderOnFailedStyle.RetryButton then
		if p1.props.onRetry then
			return Roact.createElement(Button, {
				buttonType = ButtonType.Secondary,
				size = UDim2.fromOffset(44, 44),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5),
				onActivated = p1.props.onRetry,
				icon = Images["icons/common/refresh"]
			})
		end

		error("OnRetry callback empty. OnRetry needs to be a function to render the RetryButton")

		return
	end

	error("Failed to provide proper RenderOnFailedStyle")
end

return v10
