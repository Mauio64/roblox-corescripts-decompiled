local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel")

local fFlagAXTryOnBackgroundRespectsSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXTryOnBackgroundRespectsSelection

local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local avatarBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local function selectTryOnBackgroundId(p2)
	local avatarExperience = p2 and (p2.AvatarExperience or p2)
	local avatarScene = avatarExperience and avatarExperience.AvatarScene
	local tryOnItems = avatarScene and avatarScene.OutfitTryOn and avatarScene.OutfitTryOn.TryOnItems

	if not tryOnItems then
		return nil
	end

	for k, tryOnItem in tryOnItems do
		if
			tryOnItem.isUnequipped
			or not (not fFlagAXTryOnBackgroundRespectsSelection or tryOnItem.selectedInTryOnManager ~= false or tryOnItem.lookId == nil)
			or tryOnItem.itemType ~= itemTypeEnum.Asset
			or tryOnItem.itemSubType ~= avatarBackground
		then
			continue
		end

		local itemId = tonumber(tryOnItem.itemId)

		if itemId then
			return itemId
		end
	end

	return nil
end

return selectTryOnBackgroundId
