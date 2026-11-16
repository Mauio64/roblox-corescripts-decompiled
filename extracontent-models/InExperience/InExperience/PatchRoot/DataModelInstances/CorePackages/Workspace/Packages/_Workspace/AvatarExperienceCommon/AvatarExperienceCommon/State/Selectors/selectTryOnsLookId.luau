local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)

local LOOK_TYPE = Constants.LOOK_TYPE

local function selectTryOnsLookId(p)
	if p.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledLookType == LOOK_TYPE.Makeup then
		return p.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId
	end

	return p.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end

return selectTryOnsLookId
