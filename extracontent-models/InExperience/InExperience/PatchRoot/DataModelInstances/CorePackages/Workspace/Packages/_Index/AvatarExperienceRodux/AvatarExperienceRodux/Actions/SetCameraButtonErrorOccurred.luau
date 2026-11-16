local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local ArgCheck = require(parent.ArgCheck)
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(errorOccurred)
	ArgCheck.isType(errorOccurred, "boolean", "Actions.SetCameraButton.errorOccurred")
	return { errorOccurred = errorOccurred }
end)
