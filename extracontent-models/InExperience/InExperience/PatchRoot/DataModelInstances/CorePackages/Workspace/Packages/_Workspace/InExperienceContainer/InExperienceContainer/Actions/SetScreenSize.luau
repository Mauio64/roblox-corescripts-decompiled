local parent = script:FindFirstAncestor("InExperienceContainer").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(screenSize)
	return { screenSize = screenSize }
end)
