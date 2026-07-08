local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("UnifiedLogging").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("LuaAppFeedImpressionsHundredthsPercent", 10000)
local t1 = {
	eventName = "sduiFeedImpressions",
	description = "Feed-level section impressions for SDUI feed containers (e.g. SduiVerticalFeed)",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = {
		26,
		5,
		11
	}
}
local v7 = t.strictInterface({
	pageContext = t.string,
	feedItemPositions = t.string,
	feedCollectionIds = t.string,
	feedComponentTypes = t.string
})

local function sendSduiFeedImpressions(t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}, s1: string) -- line: 26
	-- upvalues: DiscoveryEventErrorLogger (copy), v7 (copy), TelemetryService (copy), t1 (copy)
	if #t2 == 0 then
		return
	end

	if #t2 ~= #t3 or #t2 ~= #t4 then
		DiscoveryEventErrorLogger.reportError("SendSduiFeedImpressionsArrayLengthMismatch", `feedItemPositions ({ #t2 }), feedCollectionIds ({ #t3 }), and feedComponentTypes ({ #t4 }) must have equal length`, {
			feedItemPositionsCount = #t2,
			feedCollectionIdsCount = #t3,
			feedComponentTypesCount = #t4
		})

		return
	end

	local t5 = {
		pageContext = s1,
		feedItemPositions = table.concat(t2, ","),
		feedCollectionIds = table.concat(t3, ","),
		feedComponentTypes = table.concat(t4, ",")
	}
	local v14, v15 = v7(t5)

	if not v14 then
		DiscoveryEventErrorLogger.reportError("SduiFeedImpressionsEventInvalidInterface", v15)

		return
	end

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = t5
	})
end

return sendSduiFeedImpressions
