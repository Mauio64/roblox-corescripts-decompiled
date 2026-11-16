local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Sizing = require(script.Parent.Parent.Parent.Sizing)

local function BubbleItemFrame(p)
	local v = Sizing.useSizing()
	local tag = Foundation.Hooks.useDefaultTags(v.row.tag, "col size-full-0 auto-y")
	return React.createElement(Foundation.View, { tag = tag }, p.children)
end

return BubbleItemFrame
