local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local MessageInlineItemMetrics = require(script.Parent.MessageInlineItemMetrics)

local function InlineItemFrame(p)
	return React.createElement(Foundation.View, {
		tag = "col size-full-0 auto-y",
		sizeConstraint = {
			MinSize = Vector2.new(0, MessageInlineItemMetrics.MIN_HEIGHT)
		}
	}, p.children)
end

return InlineItemFrame
