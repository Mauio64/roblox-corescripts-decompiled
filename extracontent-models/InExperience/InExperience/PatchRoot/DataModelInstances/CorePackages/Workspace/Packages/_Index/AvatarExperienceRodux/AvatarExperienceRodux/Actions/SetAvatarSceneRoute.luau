local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(Parent.Rodux)
local ArgCheck = require(Parent.ArgCheck)

require(Parent.AvatarExperienceNavigation)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 9
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "avatarRoute")

	return {
		avatarRoute = p1
	}
end)
