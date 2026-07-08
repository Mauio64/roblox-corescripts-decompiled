local CrossExperience = script:FindFirstAncestor("CrossExperience")

return require(CrossExperience.dependencies).Rodux.makeActionCreator(script.Name, function() -- line: 6
	return {}
end)
