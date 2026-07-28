local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local MomentsCommon = require(Parent.MomentsCommon)

require(Parent.DataHydration.MomentsStoreTypes)

local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity

local function buildTileFields(p1, s1: string, s2: string, n1: number, s3: string?) -- line: 65
	-- upvalues: GetFFlagMomentsAnalyticsSchemaIdentity (copy), MomentsCommon (copy)
	if GetFFlagMomentsAnalyticsSchemaIdentity() then
		local recommendationMetadata = p1.recommendationMetadata
		local v13 = if recommendationMetadata == nil then nil else recommendationMetadata.feedItemId

		if v13 == nil or v13 == "" then
			local v14 = v13 ~= nil and "empty" or "nil"

			MomentsCommon.Analytics.reportMomentSkip("tile", v14, {
				entry = "profile",
				parentEntity = s2
			})

			return nil
		end

		local t1 = {
			surface = "profile",
			parentEntity = s2,
			surfaceId = s1,
			feedItemId = v13,
			tileIndex = tostring(n1)
		}

		if s3 ~= nil then
			t1.interactionType = s3
		end

		return t1
	end

	local t2 = {
		userId = s1
	}
	local recommendationMetadata = p1.recommendationMetadata

	t2.itemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId or "" else ""
	t2.gridIndex = tostring(n1)

	return t2
end

return {
	INTERACTION_OPEN = "open",
	getTileMomentId = function(p2) -- line: 43
		local recommendationMetadata = p2.recommendationMetadata

		if recommendationMetadata == nil then
			return ""
		end

		return recommendationMetadata.feedItemId or ""
	end,
	makeProfileTileImpressionFields = function(p3, s4: string, s5: string, n2: number) -- line: 108
		-- upvalues: buildTileFields (copy)
		return (buildTileFields(p3, s4, s5, n2, nil))
	end,
	makeProfileTileInteractionFields = function(p4, s6: string, s7: string, n3: number) -- line: 119
		-- upvalues: buildTileFields (copy)
		return (buildTileFields(p4, s6, s7, n3, "open"))
	end
}
