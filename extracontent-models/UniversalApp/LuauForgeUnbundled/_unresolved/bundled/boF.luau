local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/dependencies")
require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Types")

return dependencies.Rodux.makeActionCreator("RestoreState", function(p2)
	return { payload = p2 }
end)
