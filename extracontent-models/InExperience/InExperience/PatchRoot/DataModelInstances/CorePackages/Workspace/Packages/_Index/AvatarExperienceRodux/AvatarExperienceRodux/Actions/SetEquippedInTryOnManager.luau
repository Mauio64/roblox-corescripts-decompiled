local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)
require(parent.AvatarExperienceModel)

return Rodux.makeActionCreator(script.Name, function(itemId: string, selectedInTryOnManager: boolean, itemType)
	return { itemId = itemId, selectedInTryOnManager = selectedInTryOnManager, itemType = itemType }
end)
