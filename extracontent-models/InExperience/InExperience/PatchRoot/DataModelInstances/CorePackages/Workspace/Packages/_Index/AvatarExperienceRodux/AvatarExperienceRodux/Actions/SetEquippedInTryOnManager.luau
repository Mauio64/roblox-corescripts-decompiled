local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(Parent.Rodux)

require(Parent.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(s1: string, b1: boolean, p1) -- line: 13
	return {
		itemId = s1,
		selectedInTryOnManager = b1,
		itemType = p1
	}
end)
