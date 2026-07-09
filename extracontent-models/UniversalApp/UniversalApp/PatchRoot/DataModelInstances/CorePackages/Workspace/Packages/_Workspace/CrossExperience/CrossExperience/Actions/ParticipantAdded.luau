local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)

require(CrossExperience.Types)

return dependencies.Rodux.makeActionCreator(script.Name, function(p1) -- line: 7
	return {
		payload = {
			participant = p1
		}
	}
end)
