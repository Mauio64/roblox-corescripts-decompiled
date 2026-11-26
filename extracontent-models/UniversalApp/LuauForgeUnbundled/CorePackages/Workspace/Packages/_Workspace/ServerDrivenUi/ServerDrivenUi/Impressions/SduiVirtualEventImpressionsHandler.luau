local VirtualEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VirtualEvents")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local v5 = {}

local function SduiVirtualEventImpressionsHandler(p2, list, p3, p4, p5)
	if #list == 0 or #(p3 or v5) == 0 then
		sduiLogger.reportError(sduiErrors.SduiErrorType.FailedToLogVirtualEventImpressions, {
			name = "SduiVirtualEventImpressionsHandler",
			message = `No entries to log: impressionIndexes={#list}, itemAnalyticsDatas={#(p3 or v5)}`
		}, p2.appPage)
		return
	end

	local v6 = tostring(findAnalyticsFieldInAncestors("channel", { analyticsData = p4 }, p2.appPage))
	local count = 0

	for k, item in list do
		local v7 = p3[item]

		if v7 == nil then
			continue
		end

		local eventId = v7.eventId

		if not (eventId ~= nil and eventId ~= "") then
			continue
		end

		VirtualEvents.fireVirtualEventImpression({
			virtualEventId = tostring(eventId),
			universeId = tostring(v7.universeId or ""),
			channel = v6
		})

		count += 1
	end

	if count == 0 then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToLogVirtualEventImpressions,
			{
				name = "SduiVirtualEventImpressionsHandler",
				message = "No valid items found for impression indexes"
			},
			p2.appPage
		)
	end
end

return SduiVirtualEventImpressionsHandler
