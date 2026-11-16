local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(position, rotation, scale, itemId)
	return { position = position, rotation = rotation, scale = scale, itemId = itemId }
end)
