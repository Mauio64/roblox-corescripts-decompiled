local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsStoreTypes")

local function buildTileFields(p2, p3, p4, p5, interactionType)
	local recommendationMetadata = p2.recommendationMetadata
	local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil

	if feedItemId == nil or feedItemId == "" then
		local v5 = feedItemId == nil and "nil" or "empty"

		MomentsCommon.Analytics.reportMomentSkip("tile", v5, {
			entry = "profile",
			parentEntity = p4
		})

		return nil
	else
		local v5 = {
			surface = "profile",
			parentEntity = p4,
			surfaceId = p3,
			feedItemId = feedItemId,
			tileIndex = tostring(p5)
		}

		if interactionType ~= nil then
			v5.interactionType = interactionType
		end

		return v5
	end
end

return {
	makeProfileTileImpressionFields = function(p2, p3, p4, p5)
		return buildTileFields(p2, p3, p4, p5, nil)
	end,
	makeProfileTileInteractionFields = function(p2, p3, p4, p5)
		return buildTileFields(p2, p3, p4, p5, "open")
	end,
	INTERACTION_OPEN = "open"
}
