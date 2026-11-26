local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagAXOutfitSaveSkipUnownedTryOnBackground = AvatarExperienceFlags.FFlagAXOutfitSaveSkipUnownedTryOnBackground
local fFlagAXTryOnBackgroundRespectsSelection = AvatarExperienceFlags.FFlagAXTryOnBackgroundRespectsSelection

local avatarBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground
local NO_BACKGROUND_ASSET_ID = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/constants").NO_BACKGROUND_ASSET_ID
local selectTryOnBackgroundId = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/selectTryOnBackgroundId")

local function scanTryOnForBackground(tryOnItems)
	if not tryOnItems then
		return nil
	end

	for k, item in tryOnItems do
		if item.isUnequipped or item.itemType ~= "Asset" or item.itemSubType ~= avatarBackground then
			continue
		end

		local itemId = tonumber(item.itemId)

		if itemId then
			return itemId
		end
	end

	return nil
end

local function firstEquippedBackgroundId(p2)
	if not p2 then
		return nil
	end

	local v5 = p2[avatarBackground]

	if not v5 then
		return nil
	end

	for k in v5 do
		local v6 = tonumber(k)

		if v6 then
			return v6
		end
	end

	return nil
end

local function selectActiveBackground(p2, p3)
	if not avatarBackground then
		return nil
	end

	local avatarExperience = p2 and (p2.AvatarExperience or p2)

	local v5 = fFlagAXOutfitSaveSkipUnownedTryOnBackground

	if v5 then
		v5 = not (p3 == nil) and p3.ignoreTryOn == true
	end

	if AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration and not v5 then
		local v6

		if fFlagAXTryOnBackgroundRespectsSelection then
			v6 = selectTryOnBackgroundId(avatarExperience)
		else
			local outfitTryOn = avatarExperience
				and avatarExperience.AvatarScene
				and avatarExperience.AvatarScene.OutfitTryOn
			v6 = scanTryOnForBackground(outfitTryOn and outfitTryOn.TryOnItems)
		end

		if v6 then
			return v6
		end
	end

	local profileConfiguration = avatarExperience
		and avatarExperience.AvatarScene
		and avatarExperience.AvatarScene.ProfileConfiguration

	if profileConfiguration and profileConfiguration.BackgroundAssetId ~= nil then
		local backgroundAssetId = profileConfiguration.BackgroundAssetId

		if backgroundAssetId == NO_BACKGROUND_ASSET_ID then
			return nil
		end

		return backgroundAssetId
	else
		local character = avatarExperience
			and avatarExperience.AvatarEditor
			and avatarExperience.AvatarEditor.Character
		local equippedAssets = character and character.EquippedAssets

		if not equippedAssets then
			return nil
		end

		local equippedAsset = equippedAssets[avatarBackground]

		if not equippedAsset then
			return nil
		end

		for k in equippedAsset do
			local v6 = tonumber(k)

			if v6 then
				return v6
			end
		end

		return nil
	end
end

return selectActiveBackground
