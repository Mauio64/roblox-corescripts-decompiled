local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.DataHydration.MomentsStoreTypes)

local function buildTileFields(p, surfaceId: string, parentEntity: string, p2: number, interactionType: string?)
	local recommendationMetadata = p.recommendationMetadata
	local feedItemId

	if recommendationMetadata ~= nil then
		feedItemId = recommendationMetadata.feedItemId
	end

	if feedItemId == nil or feedItemId == "" then
		local v = feedItemId == nil and "nil" or "empty"

		MomentsCommon.Analytics.reportMomentSkip("tile", v, {
			entry = "profile",
			parentEntity = parentEntity
		})

		return nil
	else
		local v = {
			surface = "profile",
			parentEntity = parentEntity,
			surfaceId = surfaceId,
			feedItemId = feedItemId,
			tileIndex = tostring(p2)
		}

		if interactionType ~= nil then
			v.interactionType = interactionType
		end

		return v
	end
end

local MakeProfileTileFields = {}

function MakeProfileTileFields.makeProfileTileImpressionFields(p, surfaceId: string, parentEntity: string, p2: number)
	return buildTileFields(p, surfaceId, parentEntity, p2, nil)
end

function MakeProfileTileFields.makeProfileTileInteractionFields(p, surfaceId: string, parentEntity: string, p2: number)
	return buildTileFields(p, surfaceId, parentEntity, p2, "open")
end

MakeProfileTileFields.INTERACTION_OPEN = "open"
return MakeProfileTileFields
