local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local InterventionPlacement = require(InterventionShared.Contexts.InterventionPlacement)
local React = require(InterventionSharedParent.React)

return function() -- line: 7
	-- upvalues: React (copy), InterventionPlacement (copy)
	return React.useContext(InterventionPlacement)
end
