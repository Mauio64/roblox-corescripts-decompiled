local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local MomentsGetPostAssetStore = require(parent.DataHydration.MomentsGetPostAssetStore)
local GetFFlagMomentsRenderPostAssets = require(parent.MomentsCommon.GetFFlagMomentsRenderPostAssets)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local FFlagMomentsImpressionPrimaryEntity = require(Moments.Flags.FFlagMomentsImpressionPrimaryEntity)
local deriveMomentFromPost = require(Moments.Utils.deriveMomentFromPost)

local _ = { Video = 1, Screenshot = 2, AvatarOutfit = 3 }

local v = { [Enum.CaptureType.Video] = 1, [Enum.CaptureType.Screenshot] = 2 }

local function resolveTryOnOutfitId(data, flag: boolean)
	if not (FFlagMomentsAvatarLookTryOn and flag) then
		return 0
	end

	if data.metadata.outfitId ~= nil then
		return data.metadata.outfitId
	end

	local postAssetId

	if data.postAsset ~= nil then
		postAssetId = data.postAsset.postAssetId
	end

	if not GetFFlagMomentsRenderPostAssets() or postAssetId == nil or postAssetId <= 0 then
		return 0
	end

	local data2 = MomentsGetPostAssetStore(false).getCachedPostAsset(postAssetId).data(false)

	if data2 == nil then
		return nil
	end

	local v2 = deriveMomentFromPost(data, data2)

	if v2 == nil then
		return 0
	end

	return v2.metadata.outfitId or 0
end

local function makeMomentViewBeganFields(data, p: string, viewId: string?, flag: boolean?)
	local recommendationMetadata = data.recommendationMetadata
	local feedItemId = recommendationMetadata.feedItemId

	if feedItemId == nil or feedItemId == "" then
		local v2 = feedItemId == nil and "nil" or "empty"
		MomentsCommon.Analytics.reportMomentSkip("impression", v2, { entry = p })
		return nil
	else
		local v2 = {
			momentId = data.momentId,
			feedItemId = feedItemId,
			feedSessionId = recommendationMetadata.tracingId or "",
			viewMode = "vertical",
			source = p
		}

		local universeId = data.metadata.universeId

		if universeId ~= nil and universeId > 0 then
			v2.destinationUniverseId = tostring(universeId)
		end

		if FFlagMomentsImpressionPrimaryEntity then
			local tryOnOutfitId = resolveTryOnOutfitId(data, flag == true)

			if tryOnOutfitId == nil or not (tryOnOutfitId > 0) then
				if tryOnOutfitId ~= nil then
					local v3 = v[data.metadata.captureType]

					if v3 ~= nil then
						v2.primaryEntityType = tostring(v3)
					end

					if universeId ~= nil and universeId > 0 then
						v2.primaryCtaEntityId = tostring(universeId)
					end
				end
			else
				v2.primaryEntityType = tostring(3)
				v2.primaryCtaEntityId = tostring(tryOnOutfitId)
			end
		end

		if viewId ~= nil then
			v2.viewId = viewId
		end

		return v2
	end
end

return makeMomentViewBeganFields
