local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local ArgCheck = require(parent.ArgCheck)
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(assetId: string, assetTypeIdString: string)
	ArgCheck.isType(assetId, "string", "SetAnimationPreview: assetId")
	ArgCheck.isType(assetTypeIdString, "string", "SetAnimationPreview: assetTypeIdString")

	return { assetId = assetId, assetTypeIdString = assetTypeIdString }
end)
