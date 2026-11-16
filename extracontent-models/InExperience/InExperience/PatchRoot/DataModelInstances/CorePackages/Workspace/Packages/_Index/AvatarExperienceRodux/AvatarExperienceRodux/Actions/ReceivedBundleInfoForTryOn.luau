local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(itemId: string, outfitId: string?)
	return { itemId = itemId, outfitId = outfitId }
end)
