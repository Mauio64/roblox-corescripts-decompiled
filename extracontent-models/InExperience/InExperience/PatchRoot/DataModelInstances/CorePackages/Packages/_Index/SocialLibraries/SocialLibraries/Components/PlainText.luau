local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local ChatBubbleContainer = require(script.Parent.ChatBubbleContainer)
local roact = dependencies.Roact
local withStyle = dependencies.UIBlox.Style.withStyle
local fitTextLabel = dependencies.RoactFitComponents.FitTextLabel

local extended = roact.PureComponent:extend("PlainText")
extended.defaultProps = {
	text = "",
	maxWidth = 0,
	innerPadding = 0,
	isIncoming = false,
	hasTail = false,
	LayoutOrder = 0,
	isPending = false,
	[roact.Change.AbsoluteSize] = function() end
}

function extended.render(p)
	return withStyle(function(p2)
		local maxWidth = p.props.maxWidth
		local innerPadding = p.props.innerPadding
		local maximumWidth = math.max(0, maxWidth - innerPadding)
		local body = p2.Font.Body
		local v = p2.Font.BaseSize * body.RelativeSize

		return roact.createElement(ChatBubbleContainer, {
			isIncoming = p.props.isIncoming,
			hasTail = p.props.hasTail,
			isPending = p.props.isPending,
			padding = innerPadding,
			LayoutOrder = p.props.LayoutOrder,
			[roact.Change.AbsoluteSize] = p.props[roact.Change.AbsoluteSize]
		}, {
			textContent = roact.createElement(fitTextLabel, {
				Text = p.props.text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextColor3 = p2.Theme.TextEmphasis.Color,
				width = fitTextLabel.Width.FitToText,
				maximumWidth = maximumWidth,
				Font = p.props.font or body.Font,
				TextSize = p.props.textSize or v,
				TextTransparency = p.props.isPending and p2.Theme.TextMuted.Transparency or 0,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		})
	end)
end

return extended
