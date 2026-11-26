local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/ArgCheck")
return require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux").makeActionCreator("SetSpawnEffectPreview", function(p2)
	if p2 ~= nil then
		ArgCheck.isType(p2, "string", "SetSpawnEffectPreview: assetId")
	end

	return { assetId = p2 }
end)
