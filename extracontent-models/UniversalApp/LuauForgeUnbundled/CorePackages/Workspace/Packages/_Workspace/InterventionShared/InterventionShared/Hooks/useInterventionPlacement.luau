local InterventionPlacement = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Contexts/InterventionPlacement")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")

return function()
	return React.useContext(InterventionPlacement)
end
