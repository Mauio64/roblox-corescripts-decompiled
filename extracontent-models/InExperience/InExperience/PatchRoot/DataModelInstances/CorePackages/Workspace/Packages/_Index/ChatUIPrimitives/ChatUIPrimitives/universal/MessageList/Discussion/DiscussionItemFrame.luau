local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Sizing = require(script.Parent.Parent.Parent.Sizing)

local function DiscussionItemFrame(p)
	local frameTag = Sizing.useSizing().discussion.frameTag
	return React.createElement(Foundation.View, { tag = frameTag }, p.children)
end

return DiscussionItemFrame
