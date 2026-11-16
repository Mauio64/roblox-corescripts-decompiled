local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)
require(CrossExperience.Types)

return dependencies.Rodux.makeActionCreator(script.Name, function(payload)
	return { payload = payload }
end)
