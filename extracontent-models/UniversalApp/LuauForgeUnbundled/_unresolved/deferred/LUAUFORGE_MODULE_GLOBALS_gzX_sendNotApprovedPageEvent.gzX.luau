local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChat/Cryo")
local module2 = require("@luauforge/deferred/gzV")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("NotApprovedPageEventThrottleHunderedthsPercent", 10000)

function LUAUFORGE_MODULE_GLOBALS_gzX_sendNotApprovedPageEvent(options)
	module2.assert(
		options ~= nil,
		"Additional arguments need to be provided to NotApprovedPageEventReporter."
	)
	module2.assert(
		options.eventType ~= nil,
		"Event type needs to be provided to NotApprovedPageEventReporter"
	)

	TelemetryService:LogEvent({
		eventName = "NotApprovedPageEvent",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 6, 12 },
		description = "Event for the Not Approved Page",
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/trustsafety/trustsafety_not_approved_page_event.proto"
	}, {
		customFields = Cryo.Dictionary.join(options or {}, {
			context = "NotApprovedPageV2",
			timestamp = DateTime.now().UnixTimestampMillis,
			platform = "UniversalApp",
			sid = RbxAnalyticsService:GetSessionId()
		})
	})
end

return LUAUFORGE_MODULE_GLOBALS_gzX_sendNotApprovedPageEvent
