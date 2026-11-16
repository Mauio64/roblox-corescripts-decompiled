local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local ArgCheck = require(parent.ArgCheck)
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(assetId: string?)
	if assetId ~= nil then
		ArgCheck.isType(assetId, "string", "SetSpawnEffectPreview: assetId")
	end

	return { assetId = assetId }
end)
