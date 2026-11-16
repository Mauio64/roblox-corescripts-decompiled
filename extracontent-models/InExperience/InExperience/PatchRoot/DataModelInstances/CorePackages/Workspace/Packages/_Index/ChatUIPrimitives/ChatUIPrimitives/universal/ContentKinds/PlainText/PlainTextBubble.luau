local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local BubbleStyleContext = require(script.Parent.Parent.Parent.MessageList.Bubble.BubbleStyleContext)
local useBubbleTextConstraint = require(script.Parent.Parent.useBubbleTextConstraint)
require(script.Parent.PlainTextTypes)

local function PlainTextBubble(p)
	local v, fontStyle = BubbleStyleContext.useBubbleFontStyle()
	local v2 = SignalsReact.useSignalBinding(p.getContent)
	local sizeConstraint = useBubbleTextConstraint()

	return React.createElement(Foundation.Text, {
		tag = "auto-xy text-wrap text-align-x-left text-align-y-top",
		Text = v2:map(function(p2)
			return p2.displayText.text
		end),
		textStyle = v.textStyle,
		fontStyle = fontStyle,
		sizeConstraint = sizeConstraint,
		LayoutOrder = p.LayoutOrder
	})
end

return PlainTextBubble
