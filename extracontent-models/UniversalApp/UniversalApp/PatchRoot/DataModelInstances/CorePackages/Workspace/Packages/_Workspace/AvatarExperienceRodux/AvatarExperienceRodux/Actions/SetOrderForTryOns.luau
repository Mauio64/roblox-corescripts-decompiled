local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(Parent.Rodux)

require(Parent.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 20
	return {
		itemIdToOrderMap = p1
	}
end)
