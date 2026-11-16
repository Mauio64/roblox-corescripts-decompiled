local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/DiscoveryUtils").DiscoveryEventErrorLogger

local v5 = {
	eventName = "sduiFeedImpressions",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("LuaAppFeedImpressionsHundredthsPercent", 10000),
	lastUpdated = { 26, 5, 11 },
	description = "Feed-level section impressions for SDUI feed containers (e.g. SduiVerticalFeed)"
}

local strictInterface = t.strictInterface({
	pageContext = t.string,
	feedItemPositions = t.string,
	feedCollectionIds = t.string,
	feedComponentTypes = t.string
})

local function sendSduiFeedImpressions(list, list2, list3, p2)
	if #list == 0 then
		return
	end

	if #list ~= #list2 or #list ~= #list3 then
		discoveryEventErrorLogger.reportError(
			"SendSduiFeedImpressionsArrayLengthMismatch",
			`feedItemPositions ({#list}), feedCollectionIds ({#list2}), and feedComponentTypes ({#list3}) must have equal length`,
			{
				feedItemPositionsCount = #list,
				feedCollectionIdsCount = #list2,
				feedComponentTypesCount = #list3
			}
		)

		return
	end

	local v6 = {
		pageContext = p2,
		feedItemPositions = table.concat(list, ","),
		feedCollectionIds = table.concat(list2, ","),
		feedComponentTypes = table.concat(list3, ",")
	}

	local v7, v8 = strictInterface(v6)

	if v7 then
		TelemetryService:LogEvent(v5, {
			eventContext = p2,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = v6
		})
	else
		discoveryEventErrorLogger.reportError("SduiFeedImpressionsEventInvalidInterface", v8)
	end
end

return sendSduiFeedImpressions
