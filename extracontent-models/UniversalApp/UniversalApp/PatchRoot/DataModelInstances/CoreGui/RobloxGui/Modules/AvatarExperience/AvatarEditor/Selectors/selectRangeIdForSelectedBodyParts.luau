local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)

local FFlagAXColorAdjustmentButtonShouldAccountForTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local v5 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then require(Modules.AvatarExperience.Common.Selectors.selectAvatarPreviewColors) else AvatarExperienceCommon.State.Selectors.selectAvatarPreviewColors
local selectHasBodyTryOn = AvatarExperienceCommon.State.Selectors.selectHasBodyTryOn
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)

local function selectRangeIdForSelectedBodyParts(p1) -- line: 29
	-- upvalues: Constants (copy), selectHasBodyTryOn (copy), Utils (copy), v5 (copy)
	local AvatarExperience = p1.AvatarExperience
	local selectedBodyPartIndex = AvatarExperience.AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex
	local bodyPartForSkinColoringIds = Constants.BodyPartButtonData[selectedBodyPartIndex].bodyPartForSkinColoringIds

	if bodyPartForSkinColoringIds == nil or #bodyPartForSkinColoringIds == 0 then
		return nil
	end

	local BodyPartColorRangeIds = AvatarExperience.AvatarScene.OutfitTryOn.BodyPartColorRangeIds
	local v15 = selectHasBodyTryOn(p1) and BodyPartColorRangeIds or AvatarExperience.AvatarEditor.Character.BodyPartRangeIds
	local v16 = Utils.getRangeIdSharedByBodyParts(bodyPartForSkinColoringIds, v15)

	if v16 == nil then
		return nil
	end

	local v17 = v5(p1)

	if Utils.getColor3SharedByBodyParts(bodyPartForSkinColoringIds, v17) == nil then
		return nil
	end

	return v16
end

return selectRangeIdForSelectedBodyParts
