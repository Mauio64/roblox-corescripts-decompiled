local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)

require(CrossExperience.Types)

return dependencies.Rodux.makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		payload = p1
	}
end)
