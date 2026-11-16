local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local AvatarExperienceFlags = require(AvatarExperienceCommon.Parent.AvatarExperienceFlags)
local FFlagAXOutfitSaveSkipUnownedTryOnBackground = AvatarExperienceFlags.FFlagAXOutfitSaveSkipUnownedTryOnBackground

local selectActiveBackground = require(script.Parent.selectActiveBackground)
local selectTryOnBackgroundId = require(script.Parent.selectTryOnBackgroundId)
local constants = require(script.Parent.constants)
local NO_BACKGROUND_ASSET_ID = constants.NO_BACKGROUND_ASSET_ID

local function isAssetOwned(p, p2: number): boolean -- 1 equivalent call inferred from this helper
	local avatarExperience = p and (p.AvatarExperience or p)
	local assetInfos = avatarExperience and avatarExperience.Common and avatarExperience.Common.AssetInfos
	local v = assetInfos and assetInfos[tostring(p2)]
	return v ~= nil and v.isOwned == true
end

local function buildOutfitProfileConfiguration(p)
	local backgroundAssetId = selectActiveBackground(p)

	if
		FFlagAXOutfitSaveSkipUnownedTryOnBackground
		and backgroundAssetId ~= nil
		and backgroundAssetId == selectTryOnBackgroundId(p)
		and not isAssetOwned(p, backgroundAssetId) -- inferred equivalent call
	then
		backgroundAssetId = selectActiveBackground(p, { ignoreTryOn = true })
	end

	if backgroundAssetId == nil then
		backgroundAssetId = NO_BACKGROUND_ASSET_ID
	end

	return { BackgroundAssetId = backgroundAssetId }
end

return buildOutfitProfileConfiguration
