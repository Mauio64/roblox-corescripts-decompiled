local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local ArgCheck = require(Parent.ArgCheck)

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 11
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "boolean", "Actions.SetCameraButton.status")

	return {
		status = p1
	}
end)
