local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(itemId, itemType)
	return { itemId = itemId, itemType = itemType }
end)
