local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local ChatBubbleContainerAutomaticSize = require(script.Parent.ChatBubbleContainerAutomaticSize)
local roact = dependencies.Roact
local withStyle = dependencies.UIBlox.Style.withStyle
local normalizeFontFace = dependencies.Foundation.Utility.normalizeFontFace
local useTextBounds = require(SocialLibraries.Utils.useTextBounds)

game:DefineFastFlag("FixPlainTextAutomaticSizeClippingText", false)

local fastFlag = game:GetFastFlag("FixPlainTextAutomaticSizeClippingText")

local v = {
	text = "",
	maxWidth = 0,
	innerPadding = 0,
	isIncoming = false,
	hasTail = false,
	LayoutOrder = 0,
	isPending = false,
	[roact.Change.AbsoluteSize] = function() end
}

local function TextContent(props)
	local v2 = useTextBounds(props.text, props.font, props.textSize, props.contentMaxWidth)
		or Vector2.new(0, props.textSize)

	return roact.createElement("TextLabel", {
		Text = props.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		TextColor3 = props.textColor3,
		AutomaticSize = Enum.AutomaticSize.XY,
		FontFace = normalizeFontFace(props.font),
		TextSize = props.textSize,
		Size = fastFlag and UDim2.fromOffset(math.ceil(v2.X), (math.ceil(v2.Y))) or UDim2.new(0, v2.X, 0, v2.Y),
		TextTransparency = props.textTransparency,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true
	}, {
		SizeConstraint = roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(props.contentMaxWidth, 1e999)
		})
	})
end

local function PlainText(data)
	return withStyle(function(p)
		local maxWidth = data.maxWidth or v.maxWidth
		local innerPadding = data.innerPadding or v.innerPadding
		local contentMaxWidth = math.max(0, maxWidth - innerPadding)
		local body = p.Font.Body
		local textSize = data.textSize or p.Font.BaseSize * body.RelativeSize
		local text = data.text or v.text
		local font = data.font or body.Font

		return roact.createElement(ChatBubbleContainerAutomaticSize, {
			isIncoming = data.isIncoming or v.isIncoming,
			hasTail = data.hasTail or v.hasTail,
			isPending = data.isPending or v.isPending,
			padding = innerPadding,
			LayoutOrder = data.LayoutOrder or v.LayoutOrder,
			[roact.Change.AbsoluteSize] = data[roact.Change.AbsoluteSize] or v[roact.Change.AbsoluteSize]
		}, {
			textContent = roact.createElement(TextContent, {
				text = text,
				font = font,
				textSize = textSize,
				contentMaxWidth = contentMaxWidth,
				textColor3 = p.Theme.TextEmphasis.Color,
				textTransparency = data.isPending and p.Theme.TextMuted.Transparency or 0
			})
		})
	end)
end

return PlainText
