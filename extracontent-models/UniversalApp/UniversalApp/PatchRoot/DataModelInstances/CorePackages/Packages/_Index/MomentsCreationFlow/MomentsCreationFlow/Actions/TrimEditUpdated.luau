local parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

require(parent.MomentsCommon)
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(trimEdit)
	return { trimEdit = trimEdit }
end)
