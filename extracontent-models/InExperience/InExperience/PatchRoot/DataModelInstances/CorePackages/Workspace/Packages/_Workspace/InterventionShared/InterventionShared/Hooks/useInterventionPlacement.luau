local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local InterventionPlacement = require(InterventionShared.Contexts.InterventionPlacement)
local React = require(parent.React)

return function()
	return React.useContext(InterventionPlacement)
end
