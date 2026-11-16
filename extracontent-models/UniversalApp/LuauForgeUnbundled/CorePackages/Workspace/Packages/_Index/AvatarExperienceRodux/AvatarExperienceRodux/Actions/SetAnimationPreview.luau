local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/ArgCheck")
return require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux").makeActionCreator("SetAnimationPreview", function(p2, p3)
	ArgCheck.isType(p2, "string", "SetAnimationPreview: assetId")
	ArgCheck.isType(p3, "string", "SetAnimationPreview: assetTypeIdString")

	return { assetId = p2, assetTypeIdString = p3 }
end)
