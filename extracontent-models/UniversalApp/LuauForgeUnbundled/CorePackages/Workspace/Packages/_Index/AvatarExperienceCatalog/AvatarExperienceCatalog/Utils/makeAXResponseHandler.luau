local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics")
local sendAXStat = AvatarExperienceAnalytics.sendAXStat
local analyticsService = AvatarExperienceAnalytics.AnalyticsService
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")
local FFlagAXSendModelMismatchCounter = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Flags/FFlagAXSendModelMismatchCounter")

local function makeAXResponseHandler(object, p2, p3)
	local latencyCounter = if p3 then p3.latencyCounter else nil
	local modelMismatchCounter = if p3 then p3.modelMismatchCounter else nil

	local now = if latencyCounter then os.clock() else nil
	return (object:andThen(function(p4)
		if latencyCounter and now then
			sendAXStat({
				statName = latencyCounter,
				deltaMs = (os.clock() - now) * 1000
			})
		end

		local v6 = if p4 then p4.responseBody else nil
		local v7, v8 = p2(v6)

		if v8 then
			if FFlagAXSendModelMismatchCounter and modelMismatchCounter then
				analyticsService.EventStream:sendEventDeferred(
					modelMismatchCounter,
					"marketplaceModelMismatchMetric",
					{}
				)
			end

			warn(v8)
		end

		return v7
	end))
end

return makeAXResponseHandler
