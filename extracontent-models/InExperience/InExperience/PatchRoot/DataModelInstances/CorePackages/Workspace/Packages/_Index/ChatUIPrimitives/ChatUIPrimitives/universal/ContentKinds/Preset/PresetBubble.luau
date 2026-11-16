local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local escapeRichText = require(ChatUIPrimitives.Utils.escapeRichText)
local BubbleStyleContext = require(script.Parent.Parent.Parent.MessageList.Bubble.BubbleStyleContext)
local useBubbleTextConstraint = require(script.Parent.Parent.useBubbleTextConstraint)
require(script.Parent.PresetTypes)
local getPresetIconRichText = require(script.Parent.getPresetIconRichText)

local function PresetBubble(p)
	local v, fontStyle = BubbleStyleContext.useBubbleFontStyle()
	local v2 = SignalsReact.useSignalBinding(p.getContent)
	local sizeConstraint = useBubbleTextConstraint()

	local v3 = React.useMemo(function()
		return getPresetIconRichText(fontStyle.FontSize)
	end, { fontStyle.FontSize })

	return React.createElement(Foundation.Text, {
		tag = "auto-xy text-wrap text-align-x-left text-align-y-top",
		Text = v2:map(function(p2)
			return `{escapeRichText(p2.displayText)} {v3}`
		end),
		textStyle = v.textStyle,
		fontStyle = fontStyle,
		sizeConstraint = sizeConstraint,
		RichText = true,
		LayoutOrder = p.LayoutOrder
	})
end

return PresetBubble
