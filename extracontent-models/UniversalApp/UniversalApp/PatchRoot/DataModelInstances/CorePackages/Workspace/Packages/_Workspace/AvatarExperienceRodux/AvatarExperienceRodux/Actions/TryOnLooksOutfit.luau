local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(Parent.Rodux)

require(Parent.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 46
	return t1
end)
