local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local view = Foundation.View

local function AgentCardActions(p2)
	return React.createElement(view, {
		LayoutOrder = p2.layoutOrder or 3,
		tag = "row gap-small size-full-0 auto-y"
	}, p2.children)
end

return AgentCardActions
