local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local ArgCheck = require(parent.ArgCheck)
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(status)
	ArgCheck.isType(status, "boolean", "Actions.SetCameraButton.status")
	return { status = status }
end)
