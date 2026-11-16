require("@luauforge/bundled/dHK")

require("@luauforge/bundled/dMc")
local fFlagAXColorAdjustmentButtonShouldAccountForTryOns = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local v5

if fFlagAXColorAdjustmentButtonShouldAccountForTryOns then
	v5 = AvatarExperienceCommon.State.Selectors.selectAvatarPreviewColors
else
	v5 = require("@luauforge/bundled/gOy")
end

local selectHasBodyTryOn = AvatarExperienceCommon.State.Selectors.selectHasBodyTryOn

local module2 = require("@luauforge/bundled/fvh")
local module3 = require("@luauforge/bundled/dNQ")

local function selectRangeIdForBodyPartIndex(p2, p3)
	local avatarExperience = p2.AvatarExperience

	local bodyPartForSkinColoringIds = module3.BodyPartButtonData[p3].bodyPartForSkinColoringIds

	if bodyPartForSkinColoringIds == nil or #bodyPartForSkinColoringIds == 0 then
		return nil
	end

	local bodyPartColorRangeIds = avatarExperience.AvatarScene.OutfitTryOn.BodyPartColorRangeIds

	local v6 = selectHasBodyTryOn(p2) and bodyPartColorRangeIds
		or avatarExperience.AvatarEditor.Character.BodyPartRangeIds

	local rangeIdSharedByBodyParts = module2.getRangeIdSharedByBodyParts(bodyPartForSkinColoringIds, v6)

	if rangeIdSharedByBodyParts == nil then
		return nil
	end

	local v7 = v5(p2)

	if module2.getColor3SharedByBodyParts(bodyPartForSkinColoringIds, v7) == nil then
		return nil
	end

	return rangeIdSharedByBodyParts
end

return selectRangeIdForBodyPartIndex
