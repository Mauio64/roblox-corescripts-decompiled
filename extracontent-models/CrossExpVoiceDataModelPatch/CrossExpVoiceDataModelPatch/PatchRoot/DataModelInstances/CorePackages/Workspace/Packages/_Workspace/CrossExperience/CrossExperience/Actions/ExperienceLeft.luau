local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)

return dependencies.Rodux.makeActionCreator(script.Name, function()
	return {}
end)
