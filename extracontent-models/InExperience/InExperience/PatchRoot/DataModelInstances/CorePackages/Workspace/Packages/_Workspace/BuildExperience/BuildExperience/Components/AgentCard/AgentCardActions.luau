local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local function AgentCardActions(p)
	return React.createElement(View, {
		LayoutOrder = p.layoutOrder or 3,
		tag = "row gap-small size-full-0 auto-y"
	}, p.children)
end

return AgentCardActions
