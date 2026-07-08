local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local ChatBubbleContainerAutomaticSize = require(script.Parent.ChatBubbleContainerAutomaticSize)
local Roact = dependencies.Roact
local withStyle = dependencies.UIBlox.Style.withStyle
local TextService = game:GetService("TextService")

game:DefineFastFlag("FixPlainTextAutomaticSizeClippingText", false)

local FastFlag = game:GetFastFlag("FixPlainTextAutomaticSizeClippingText")
local t1 = {
	text = "",
	maxWidth = 0,
	innerPadding = 0,
	isIncoming = false,
	hasTail = false,
	LayoutOrder = 0,
	isPending = false,
	[Roact.Change.AbsoluteSize] = function() -- line: 20
	end
}

local function PlainText(p1) -- line: 23
	-- upvalues: withStyle (copy), t1 (copy), TextService (copy), Roact (copy), ChatBubbleContainerAutomaticSize (copy), FastFlag (copy)
	return withStyle(function(p2) -- line: 24
		-- upvalues: p1 (copy), t1 (copy), TextService (copy), Roact (copy), ChatBubbleContainerAutomaticSize (copy), FastFlag (copy)
		local v12 = p1.maxWidth or t1.maxWidth
		local v13 = p1.innerPadding or t1.innerPadding
		local v14 = math.max(0, v12 - v13)
		local Body = p2.Font.Body
		local v16 = p1.textSize or p2.Font.BaseSize * Body.RelativeSize
		local v17 = p1.text or t1.text
		local v18 = p1.font or Body.Font
		local vector2 = Vector2.new(v14, 1e999)
		local TextSize = TextService:GetTextSize(v17, v16, v18, vector2)

		return Roact.createElement(ChatBubbleContainerAutomaticSize, {
			isIncoming = p1.isIncoming or t1.isIncoming,
			hasTail = p1.hasTail or t1.hasTail,
			isPending = p1.isPending or t1.isPending,
			padding = v13,
			LayoutOrder = p1.LayoutOrder or t1.LayoutOrder,
			[Roact.Change.AbsoluteSize] = p1[Roact.Change.AbsoluteSize] or t1[Roact.Change.AbsoluteSize]
		}, {
			textContent = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				Text = v17,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = p2.Theme.TextEmphasis.Color,
				AutomaticSize = Enum.AutomaticSize.XY,
				Font = v18,
				TextSize = v16,
				Size = FastFlag and UDim2.fromOffset(math.ceil(TextSize.X), (math.ceil(TextSize.Y))) or UDim2.new(0, TextSize.X, 0, TextSize.Y),
				TextTransparency = p1.isPending and p2.Theme.TextMuted.Transparency or 0,
				TextYAlignment = Enum.TextYAlignment.Top
			}, {
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(v14 or v12, 1e999)
				})
			})
		})
	end)
end

return PlainText
