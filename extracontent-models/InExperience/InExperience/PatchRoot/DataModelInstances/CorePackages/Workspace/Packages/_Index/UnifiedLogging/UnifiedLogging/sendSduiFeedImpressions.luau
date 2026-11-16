local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("UnifiedLogging").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local v = {
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

local function sendSduiFeedImpressions(list, list2, list3, p: string)
	if #list == 0 then
		return
	end

	if #list ~= #list2 or #list ~= #list3 then
		DiscoveryEventErrorLogger.reportError(
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

	local customFields = {
		pageContext = p,
		feedItemPositions = table.concat(list, ","),
		feedCollectionIds = table.concat(list2, ","),
		feedComponentTypes = table.concat(list3, ",")
	}

	local v2, v3 = strictInterface(customFields)

	if v2 then
		TelemetryService:LogEvent(v, {
			eventContext = p,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = customFields
		})
	else
		DiscoveryEventErrorLogger.reportError("SduiFeedImpressionsEventInvalidInterface", v3)
	end
end

return sendSduiFeedImpressions
