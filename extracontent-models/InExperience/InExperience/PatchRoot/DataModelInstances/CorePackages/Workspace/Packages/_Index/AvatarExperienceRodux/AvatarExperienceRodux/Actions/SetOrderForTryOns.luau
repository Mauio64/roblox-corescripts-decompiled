local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)
require(parent.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(itemIdToOrderMap)
	return { itemIdToOrderMap = itemIdToOrderMap }
end)
