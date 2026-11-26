local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/dependencies")
require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Types")

return dependencies.Rodux.makeActionCreator("ParticipantAdded", function(p2)
	return {
		payload = { participant = p2 }
	}
end)
