local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local ChatBubbleContainer = require(script.Parent.ChatBubbleContainer)
local Roact = dependencies.Roact
local withStyle = dependencies.UIBlox.Style.withStyle
local FitTextLabel = dependencies.RoactFitComponents.FitTextLabel
local v7 = Roact.PureComponent:extend("PlainText")

v7.defaultProps = {
	text = "",
	maxWidth = 0,
	innerPadding = 0,
	isIncoming = false,
	hasTail = false,
	LayoutOrder = 0,
	isPending = false,
	[Roact.Change.AbsoluteSize] = function() -- line: 17
	end
}

function v7.render(p1) -- line: 20
	-- upvalues: withStyle (copy), Roact (copy), ChatBubbleContainer (copy), FitTextLabel (copy)
	return withStyle(function(p2) -- line: 21
		-- upvalues: p1 (copy), Roact (copy), ChatBubbleContainer (copy), FitTextLabel (copy)
		local maxWidth = p1.props.maxWidth
		local innerPadding = p1.props.innerPadding
		local v12 = math.max(0, maxWidth - innerPadding)
		local Body = p2.Font.Body
		local v14 = p2.Font.BaseSize * Body.RelativeSize

		return Roact.createElement(ChatBubbleContainer, {
			isIncoming = p1.props.isIncoming,
			hasTail = p1.props.hasTail,
			isPending = p1.props.isPending,
			padding = innerPadding,
			LayoutOrder = p1.props.LayoutOrder,
			[Roact.Change.AbsoluteSize] = p1.props[Roact.Change.AbsoluteSize]
		}, {
			textContent = Roact.createElement(FitTextLabel, {
				BackgroundTransparency = 1,
				Text = p1.props.text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = p2.Theme.TextEmphasis.Color,
				width = FitTextLabel.Width.FitToText,
				maximumWidth = v12,
				Font = p1.props.font or Body.Font,
				TextSize = p1.props.textSize or v14,
				TextTransparency = p1.props.isPending and p2.Theme.TextMuted.Transparency or 0,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		})
	end)
end

return v7
