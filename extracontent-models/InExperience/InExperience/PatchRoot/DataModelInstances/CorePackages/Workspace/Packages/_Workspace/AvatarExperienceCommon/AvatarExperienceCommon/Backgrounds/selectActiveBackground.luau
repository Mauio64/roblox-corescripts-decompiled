local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXOutfitSaveSkipUnownedTryOnBackground = AvatarExperienceFlags.FFlagAXOutfitSaveSkipUnownedTryOnBackground
local FFlagAXTryOnBackgroundRespectsSelection = AvatarExperienceFlags.FFlagAXTryOnBackgroundRespectsSelection

local Constants = require(AvatarExperienceCommon.Constants)

local AvatarBackground = Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground
local constants = require(script.Parent.constants)
local NO_BACKGROUND_ASSET_ID = constants.NO_BACKGROUND_ASSET_ID
local selectTryOnBackgroundId = require(script.Parent.selectTryOnBackgroundId)

local function scanTryOnForBackground(tryOnItems)
	if not tryOnItems then
		return nil
	end

	for _, item in tryOnItems do
		if item.isUnequipped or item.itemType ~= "Asset" or item.itemSubType ~= AvatarBackground then
			continue
		end

		local itemId = tonumber(item.itemId)

		if itemId then
			return itemId
		end
	end

	return nil
end

local function firstEquippedBackgroundId(equippedAssets) -- 1 equivalent call inferred from this helper
	if not equippedAssets then
		return nil
	end

	local v = equippedAssets[AvatarBackground]

	if not v then
		return nil
	end

	for k in v do
		local v2 = tonumber(k)

		if v2 then
			return v2
		end
	end

	return nil
end

local function selectActiveBackground(p, p2)
	if not AvatarBackground then
		return nil
	end

	local avatarExperience = p and (p.AvatarExperience or p)

	local v = FFlagAXOutfitSaveSkipUnownedTryOnBackground

	if v then
		if p2 == nil then
			v = false
		else
			v = p2.ignoreTryOn == true
		end
	end

	if AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration and not v then
		local v2

		if FFlagAXTryOnBackgroundRespectsSelection then
			v2 = selectTryOnBackgroundId(avatarExperience)
		else
			local outfitTryOn = avatarExperience
				and avatarExperience.AvatarScene
				and avatarExperience.AvatarScene.OutfitTryOn
			v2 = scanTryOnForBackground(outfitTryOn and outfitTryOn.TryOnItems)
		end

		if v2 then
			return v2
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
		local character = avatarExperience and avatarExperience.AvatarEditor and avatarExperience.AvatarEditor.Character
		local equippedAssets = character and character.EquippedAssets
		return firstEquippedBackgroundId(equippedAssets) -- inferred equivalent call
	end
end

return selectActiveBackground
