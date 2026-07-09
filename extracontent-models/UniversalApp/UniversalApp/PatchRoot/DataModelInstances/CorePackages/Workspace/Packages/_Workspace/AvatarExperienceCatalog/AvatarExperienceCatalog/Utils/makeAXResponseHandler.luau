local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local AvatarExperienceAnalytics = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics)
local sendAXStat = AvatarExperienceAnalytics.sendAXStat
local AnalyticsService = AvatarExperienceAnalytics.AnalyticsService

require(AvatarExperienceCatalogParent.LuauPolyfill)

local FFlagAXSendModelMismatchCounter = require(AvatarExperienceCatalog.Flags.FFlagAXSendModelMismatchCounter)

local function makeAXResponseHandler(p1, p2: ((...any) -> ...any), t1: {[any]: any}?) -- line: 11
	-- upvalues: sendAXStat (copy), FFlagAXSendModelMismatchCounter (copy), AnalyticsService (copy)
	local v11 = if not t1 then nil else t1.latencyCounter
	local v12 = if not t1 then nil else t1.modelMismatchCounter
	local v13 = if not v11 then nil else os.clock()

	return (p1:andThen(function(p3) -- line: 23
		-- upvalues: v11 (copy), v13 (copy), sendAXStat (copy), p2 (copy), FFlagAXSendModelMismatchCounter (copy), v12 (copy), AnalyticsService (copy)
		if v11 and v13 then
			local v15 = (os.clock() - v13) * 1000

			sendAXStat({
				statName = v11,
				deltaMs = v15
			})
		end

		local v16, v17 = p2(if not p3 then nil else p3.responseBody)

		if v17 then
			if FFlagAXSendModelMismatchCounter and v12 then
				AnalyticsService.EventStream:sendEventDeferred(v12, "marketplaceModelMismatchMetric", {})
			end

			warn(v17)
		end

		return v16
	end))
end

return makeAXResponseHandler
