local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(Parent.Rodux)

require(Parent.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 16
	return {
		colors = p1,
		bodyPartColorRangeIds = p2
	}
end)
