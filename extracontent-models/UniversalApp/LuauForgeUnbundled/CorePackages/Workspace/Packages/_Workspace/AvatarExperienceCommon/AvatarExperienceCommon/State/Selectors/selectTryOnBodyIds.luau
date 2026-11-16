local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel").Enums.ItemTypeEnum
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

local function getBodiesInTryOns(tryOnItems)
	local itemIds = {}

	for k, item in tryOnItems do
		if item.itemType == itemTypeEnum.Bundle and item.itemSubType == Constants.BODY_BUNDLE_TYPE_ID then
			table.insert(itemIds, item.itemId)
		end
	end

	return itemIds
end

local function selectTryOnBodyIds(p2)
	local outfitTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn

	if outfitTryOn and outfitTryOn.TryOnItems then
		return getBodiesInTryOns(outfitTryOn.TryOnItems)
	end

	return {}
end

return selectTryOnBodyIds
