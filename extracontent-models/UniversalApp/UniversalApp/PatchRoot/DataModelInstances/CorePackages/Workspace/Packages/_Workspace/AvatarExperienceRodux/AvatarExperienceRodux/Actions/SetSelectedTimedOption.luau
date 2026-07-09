local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(Parent.Rodux)

require(Parent.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(s1: string, n1: number?, p1) -- line: 13
	return {
		itemId = s1,
		selectedTimedOptionIndex = n1,
		itemType = p1
	}
end)
