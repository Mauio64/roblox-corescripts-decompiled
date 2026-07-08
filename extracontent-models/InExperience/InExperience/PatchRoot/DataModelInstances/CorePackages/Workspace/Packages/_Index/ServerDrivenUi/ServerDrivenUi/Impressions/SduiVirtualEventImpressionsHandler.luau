local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local VirtualEvents = require(Parent.VirtualEvents)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local t1 = {}

local function SduiVirtualEventImpressionsHandler(p1, t2: {[any]: any}, t3: {[any]: any}, p2, _: number?) -- line: 23
	-- upvalues: t1 (copy), SduiLogger (copy), SduiErrors (copy), findAnalyticsFieldInAncestors (copy), VirtualEvents (copy)
	if #t2 == 0 or #(t3 or t1) == 0 then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToLogVirtualEventImpressions, {
			name = "SduiVirtualEventImpressionsHandler",
			message = `No entries to log: impressionIndexes={ #t2 }, itemAnalyticsDatas={ #(t3 or t1) }`
		}, p1.appPage)

		return
	end

	local str = tostring(findAnalyticsFieldInAncestors("channel", {
		analyticsData = p2
	}, p1.appPage))
	local n2 = 0

	for _, v17 in t2 do
		local v18 = t3[v17]

		if v18 ~= nil then
			local eventId = v18.eventId

			if eventId ~= nil and eventId ~= "" then
				VirtualEvents.fireVirtualEventImpression({
					virtualEventId = tostring(eventId),
					universeId = tostring(v18.universeId or ""),
					channel = str
				})
				n2 += 1
			end
		end
	end

	if n2 == 0 then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToLogVirtualEventImpressions, {
			name = "SduiVirtualEventImpressionsHandler",
			message = "No valid items found for impression indexes"
		}, p1.appPage)
	end
end

return SduiVirtualEventImpressionsHandler
