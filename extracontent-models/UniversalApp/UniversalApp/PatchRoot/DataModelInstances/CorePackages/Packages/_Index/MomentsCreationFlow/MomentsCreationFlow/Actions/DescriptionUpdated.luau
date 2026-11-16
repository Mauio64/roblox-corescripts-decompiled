local parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(description: string)
	return { description = description }
end)
