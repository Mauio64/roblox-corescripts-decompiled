local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendAXStat = AvatarExperienceAnalytics.sendAXStat
local AnalyticsService = AvatarExperienceAnalytics.AnalyticsService
require(parent.LuauPolyfill)
local FFlagAXSendModelMismatchCounter = require(AvatarExperienceCatalog.Flags.FFlagAXSendModelMismatchCounter)

local function makeAXResponseHandler(object, callback, p)
	local latencyCounter

	if p then
		latencyCounter = p.latencyCounter
	else
		latencyCounter = nil
	end

	local modelMismatchCounter

	if p then
		modelMismatchCounter = p.modelMismatchCounter
	else
		modelMismatchCounter = nil
	end

	local now

	if latencyCounter then
		now = os.clock()
	else
		now = nil
	end

	return (object:andThen(function(p2)
		if latencyCounter and now then
			sendAXStat({
				statName = latencyCounter,
				deltaMs = (os.clock() - now) * 1000
			})
		end

		local v

		if p2 then
			v = p2.responseBody
		end

		local v2, v3 = callback(v)

		if v3 then
			if FFlagAXSendModelMismatchCounter and modelMismatchCounter then
				AnalyticsService.EventStream:sendEventDeferred(
					modelMismatchCounter,
					"marketplaceModelMismatchMetric",
					{}
				)
			end

			warn(v3)
		end

		return v2
	end))
end

return makeAXResponseHandler
