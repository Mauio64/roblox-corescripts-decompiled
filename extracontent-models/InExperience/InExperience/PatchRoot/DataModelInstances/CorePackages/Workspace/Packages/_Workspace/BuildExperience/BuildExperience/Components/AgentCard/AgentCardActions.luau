local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local View = Foundation.View

local function AgentCardActions(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		LayoutOrder = 3,
		tag = "row gap-small size-full-0 auto-y"
	}, t1.children)
end

return AgentCardActions
