local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

require(parent.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(p)
	return p
end)
