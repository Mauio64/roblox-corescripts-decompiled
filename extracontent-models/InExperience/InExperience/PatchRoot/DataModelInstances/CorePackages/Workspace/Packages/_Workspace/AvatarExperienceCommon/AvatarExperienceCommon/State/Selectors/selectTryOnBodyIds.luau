local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceModel = require(AvatarExperienceCommon.Parent.AvatarExperienceModel)

local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local Constants = require(AvatarExperienceCommon.Constants)

local function getBodiesInTryOns(tryOnItems)
	local itemIds = {}

	for _, item in tryOnItems do
		if item.itemType == ItemTypeEnum.Bundle and item.itemSubType == Constants.BODY_BUNDLE_TYPE_ID then
			table.insert(itemIds, item.itemId)
		end
	end

	return itemIds
end

local function selectTryOnBodyIds(p)
	local outfitTryOn = p.AvatarExperience.AvatarScene.OutfitTryOn

	if outfitTryOn and outfitTryOn.TryOnItems then
		return getBodiesInTryOns(outfitTryOn.TryOnItems)
	end

	return {}
end

return selectTryOnBodyIds
