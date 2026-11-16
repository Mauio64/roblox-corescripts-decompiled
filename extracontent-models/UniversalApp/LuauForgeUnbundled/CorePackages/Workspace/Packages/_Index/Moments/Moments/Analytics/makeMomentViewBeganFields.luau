local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local MomentsGetPostAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetPostAssetStore")
local GetFFlagMomentsRenderPostAssets = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/GetFFlagMomentsRenderPostAssets")
local fFlagMomentsAvatarLookTryOn = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsAvatarLookTryOn
local FFlagMomentsImpressionPrimaryEntity = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsImpressionPrimaryEntity")
local deriveMomentFromPost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/deriveMomentFromPost")

local v5 = { Video = 1, Screenshot = 2, AvatarOutfit = 3 }

local v6 = { [Enum.CaptureType.Video] = 1, [Enum.CaptureType.Screenshot] = 2 }

local function resolveTryOnOutfitId(data, p2)
	if not (fFlagMomentsAvatarLookTryOn and p2) then
		return 0
	end

	if data.metadata.outfitId ~= nil then
		return data.metadata.outfitId
	end

	local postAssetId = if data.postAsset ~= nil then data.postAsset.postAssetId else nil

	if not GetFFlagMomentsRenderPostAssets() or postAssetId == nil or postAssetId <= 0 then
		return 0
	end

	local data2 = MomentsGetPostAssetStore(false).getCachedPostAsset(postAssetId).data(false)

	if data2 == nil then
		return nil
	end

	local v7 = deriveMomentFromPost(data, data2)

	if v7 == nil then
		return 0
	end

	return v7.metadata.outfitId or 0
end

local function makeMomentViewBeganFields(data, p2, viewId, p3)
	local recommendationMetadata = data.recommendationMetadata
	local feedItemId = recommendationMetadata.feedItemId

	if feedItemId == nil or feedItemId == "" then
		local v7 = feedItemId == nil and "nil" or "empty"
		MomentsCommon.Analytics.reportMomentSkip("impression", v7, { entry = p2 })
		return nil
	else
		local v7 = {
			momentId = data.momentId,
			feedItemId = feedItemId,
			feedSessionId = recommendationMetadata.tracingId or "",
			viewMode = "vertical",
			source = p2
		}

		local universeId = data.metadata.universeId

		if universeId ~= nil and universeId > 0 then
			v7.destinationUniverseId = tostring(universeId)
		end

		if FFlagMomentsImpressionPrimaryEntity then
			local tryOnOutfitId = resolveTryOnOutfitId(data, p3 == true)

			if tryOnOutfitId == nil or not (tryOnOutfitId > 0) then
				if tryOnOutfitId ~= nil then
					local v8 = v6[data.metadata.captureType]

					if v8 ~= nil then
						v7.primaryEntityType = tostring(v8)
					end

					if universeId ~= nil and universeId > 0 then
						v7.primaryCtaEntityId = tostring(universeId)
					end
				end
			else
				v7.primaryEntityType = tostring(3)
				v7.primaryCtaEntityId = tostring(tryOnOutfitId)
			end
		end

		if viewId ~= nil then
			v7.viewId = viewId
		end

		return v7
	end
end

return makeMomentViewBeganFields
