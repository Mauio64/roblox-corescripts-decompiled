local fFlagAXOutfitSaveSkipUnownedTryOnBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXOutfitSaveSkipUnownedTryOnBackground

local selectActiveBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/selectActiveBackground")
local selectTryOnBackgroundId = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/selectTryOnBackgroundId")
local NO_BACKGROUND_ASSET_ID = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/constants").NO_BACKGROUND_ASSET_ID

local function isAssetOwned(p2, p3): boolean
	local avatarExperience = p2 and (p2.AvatarExperience or p2)
	local assetInfos = avatarExperience and avatarExperience.Common and avatarExperience.Common.AssetInfos
	local v5 = assetInfos and assetInfos[tostring(p3)]
	return v5 ~= nil and v5.isOwned == true
end

local function buildOutfitProfileConfiguration(p2)
	local v5 = selectActiveBackground(p2)

	if fFlagAXOutfitSaveSkipUnownedTryOnBackground and v5 ~= nil and v5 == selectTryOnBackgroundId(p2) then
		local avatarExperience = p2 and (p2.AvatarExperience or p2)
		local assetInfos = avatarExperience
			and avatarExperience.Common
			and avatarExperience.Common.AssetInfos
		local v6 = assetInfos and assetInfos[tostring(v5)]
		local v7 = not (v6 == nil) and v6.isOwned == true

		if not v7 then
			v5 = selectActiveBackground(p2, { ignoreTryOn = true })
		end
	end

	if v5 == nil then
		v5 = NO_BACKGROUND_ASSET_ID
	end

	return { BackgroundAssetId = v5 }
end

return buildOutfitProfileConfiguration
