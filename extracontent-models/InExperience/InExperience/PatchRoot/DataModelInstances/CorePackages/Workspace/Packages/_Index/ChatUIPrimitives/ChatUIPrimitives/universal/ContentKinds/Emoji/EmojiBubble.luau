local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local BubbleStyleContext = require(script.Parent.Parent.Parent.MessageList.Bubble.BubbleStyleContext)
local useBubbleTextConstraint = require(script.Parent.Parent.useBubbleTextConstraint)
local EmojiContentModel = require(script.Parent.EmojiContentModel)
require(script.Parent.EmojiTypes)

local function EmojiBubble(p)
	local v = Foundation.Hooks.useTokens()
	local v2 = BubbleStyleContext.useBubbleStyle()
	local v3 = SignalsReact.useSignalBinding(p.getContent)

	local fontStyle = React.useMemo(function()
		local headingSmall = v.Typography.HeadingSmall
		return {
			Font = headingSmall.Font,
			FontSize = headingSmall.FontSize,
			LineHeight = headingSmall.LineHeight
		}
	end, { v })
	local sizeConstraint = useBubbleTextConstraint()

	return React.createElement(Foundation.Text, {
		tag = "auto-xy text-wrap text-align-x-left text-align-y-top",
		Text = v3:map(EmojiContentModel.getDisplayText),
		textStyle = v2.textStyle,
		fontStyle = fontStyle,
		sizeConstraint = sizeConstraint,
		LayoutOrder = p.LayoutOrder
	})
end

return EmojiBubble
