local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local LOOK_TYPE = require(AvatarExperienceCommon.Constants).LOOK_TYPE
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping

local function selectTryOnsLookId(p1) -- line: 14
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), LOOK_TYPE (copy)
	local v8 = if not FFlagAXMISEnableMultiShopping then nil else p1.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledLookType

	if FFlagAXMISEnableMultiShopping and v8 == LOOK_TYPE.Makeup then
		return p1.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId
	end

	return p1.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end

return selectTryOnsLookId
