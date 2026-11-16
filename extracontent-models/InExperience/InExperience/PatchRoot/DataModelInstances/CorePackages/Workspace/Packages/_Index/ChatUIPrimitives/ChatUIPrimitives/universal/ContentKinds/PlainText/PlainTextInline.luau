local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.PlainTextTypes)

local function PlainTextInline(p)
	local v = SignalsReact.useSignalBinding(p.getContent)
	return React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-wrap text-align-x-left text-align-y-top",
		Text = v:map(function(p2)
			return p2.displayText.text
		end),
		LayoutOrder = p.LayoutOrder
	})
end

return PlainTextInline
