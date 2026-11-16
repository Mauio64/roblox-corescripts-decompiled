local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceModel = require(AvatarExperienceCommon.Parent.AvatarExperienceModel)

local AvatarExperienceFlags = require(AvatarExperienceCommon.Parent.AvatarExperienceFlags)
local FFlagAXTryOnBackgroundRespectsSelection = AvatarExperienceFlags.FFlagAXTryOnBackgroundRespectsSelection

local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local Constants = require(AvatarExperienceCommon.Constants)
local AvatarBackground = Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local function selectTryOnBackgroundId(p)
	local avatarExperience = p and (p.AvatarExperience or p)
	local avatarScene = avatarExperience and avatarExperience.AvatarScene
	local tryOnItems = avatarScene and avatarScene.OutfitTryOn and avatarScene.OutfitTryOn.TryOnItems

	if not tryOnItems then
		return nil
	end

	for _, tryOnItem in tryOnItems do
		if
			tryOnItem.isUnequipped
			or not (not FFlagAXTryOnBackgroundRespectsSelection or tryOnItem.selectedInTryOnManager ~= false or tryOnItem.lookId == nil)
			or tryOnItem.itemType ~= ItemTypeEnum.Asset
			or tryOnItem.itemSubType ~= AvatarBackground
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
