local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(outfitTryOns)
	return { outfitTryOns = outfitTryOns }
end)
