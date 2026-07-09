local Parent = script:FindFirstAncestor("NotApprovedPage").Parent
local Cryo = require(Parent.Cryo)
local ArgCheck = require(Parent.ArgCheck)
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")
local v6 = game:DefineFastInt("NotApprovedPageEventThrottleHunderedthsPercent", 10000)

function sendNotApprovedPageEvent(p1) -- line: 23
	-- upvalues: ArgCheck (copy), v6 (copy), Cryo (copy), RbxAnalyticsService (copy), TelemetryService (copy)
	ArgCheck.assert(p1 ~= nil, "Additional arguments need to be provided to NotApprovedPageEventReporter.")
	ArgCheck.assert(p1.eventType ~= nil, "Event type needs to be provided to NotApprovedPageEventReporter")

	local t1 = {
		eventName = "NotApprovedPageEvent",
		description = "Event for the Not Approved Page",
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/trustsafety/trustsafety_not_approved_page_event.proto",
		backends = { "EventIngest" },
		throttlingPercentage = v6,
		lastUpdated = {
			2025,
			6,
			12
		}
	}
	local v9 = Cryo.Dictionary.join(p1 or {}, {
		context = "NotApprovedPageV2",
		platform = "UniversalApp",
		timestamp = DateTime.now().UnixTimestampMillis,
		sid = RbxAnalyticsService:GetSessionId()
	})

	TelemetryService:LogEvent(t1, {
		customFields = v9
	})
end

return sendNotApprovedPageEvent
