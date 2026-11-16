local LOOK_TYPE = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").LOOK_TYPE

local function selectTryOnsLookId(p2)
	if p2.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledLookType == LOOK_TYPE.Makeup then
		return p2.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId
	end

	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end

return selectTryOnsLookId
