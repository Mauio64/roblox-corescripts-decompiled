local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local EmojiContentModel = require(script.Parent.EmojiContentModel)
require(script.Parent.EmojiTypes)

local function EmojiInline(p)
	local v = SignalsReact.useSignalBinding(p.getContent)

	return React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left text-align-y-top",
		Text = v:map(EmojiContentModel.getDisplayText),
		LayoutOrder = p.LayoutOrder
	})
end

return EmojiInline
