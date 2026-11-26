require("@luauforge/bundled/dKT")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local selectAvatarPreviewColors = AvatarExperienceCommon.State.Selectors.selectAvatarPreviewColors
local selectHasBodyTryOn = AvatarExperienceCommon.State.Selectors.selectHasBodyTryOn

local module2 = require("@luauforge/bundled/fCI")
local module3 = require("@luauforge/bundled/dRg")

local function selectRangeIdForBodyPartIndex(p2, p3)
	local avatarExperience = p2.AvatarExperience

	local bodyPartForSkinColoringIds = module3.BodyPartButtonData[p3].bodyPartForSkinColoringIds

	if bodyPartForSkinColoringIds == nil or #bodyPartForSkinColoringIds == 0 then
		return nil
	end

	local bodyPartColorRangeIds = avatarExperience.AvatarScene.OutfitTryOn.BodyPartColorRangeIds

	local v5 = selectHasBodyTryOn(p2) and bodyPartColorRangeIds
		or avatarExperience.AvatarEditor.Character.BodyPartRangeIds

	local rangeIdSharedByBodyParts = module2.getRangeIdSharedByBodyParts(bodyPartForSkinColoringIds, v5)

	if rangeIdSharedByBodyParts == nil then
		return nil
	end

	local v6 = selectAvatarPreviewColors(p2)

	if module2.getColor3SharedByBodyParts(bodyPartForSkinColoringIds, v6) == nil then
		return nil
	end

	return rangeIdSharedByBodyParts
end

return selectRangeIdForBodyPartIndex
