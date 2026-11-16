local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local VirtualEvents = require(parent.VirtualEvents)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local v = {}

local function SduiVirtualEventImpressionsHandler(p, list, p2, analyticsData, _: number?)
	if #list == 0 or #(p2 or v) == 0 then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToLogVirtualEventImpressions, {
			name = "SduiVirtualEventImpressionsHandler",
			message = `No entries to log: impressionIndexes={#list}, itemAnalyticsDatas={#(p2 or v)}`
		}, p.appPage)
		return
	end

	local channel = tostring(findAnalyticsFieldInAncestors("channel", {
		analyticsData = analyticsData
	}, p.appPage))
	local count = 0

	for _, item in list do
		local v2 = p2[item]

		if v2 == nil then
			continue
		end

		local eventId = v2.eventId

		if not (eventId ~= nil and eventId ~= "") then
			continue
		end

		VirtualEvents.fireVirtualEventImpression({
			virtualEventId = tostring(eventId),
			universeId = tostring(v2.universeId or ""),
			channel = channel
		})

		count += 1
	end

	if count == 0 then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.FailedToLogVirtualEventImpressions,
			{
				name = "SduiVirtualEventImpressionsHandler",
				message = "No valid items found for impression indexes"
			},
			p.appPage
		)
	end
end

return SduiVirtualEventImpressionsHandler
