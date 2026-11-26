local module = require("@luauforge/deferred/fbA")
local module2 = require("@luauforge/deferred/fbB")
local contexts = module2.Analytics.Enums.Contexts

local module3 = require("@luauforge/deferred/eku")
require("@luauforge/deferred/fby")
local module4 = require("@luauforge/deferred/fbC")
local module5 = require("@luauforge/deferred/fbE")

local telemetry = module2.Telemetry.new({
	name = "SchoolsAnalyticsEvent",
	description = "Schools feature view/click analytics. All events emit under the single wire name `SchoolsInteraction`; the per-emission `eventName` field distinguishes them.",
	lastUpdated = { 2026, 7, 29 },
	eventStreamCtx = contexts.Schools,
	backendsList = {
		{
			type = "EventIngest",
			overrideName = function(p2)
				return module3.Analytics.WIRE_EVENT_NAME
			end,
			format = function(p2, p3)
				return module.Dictionary.join(p2.additionalInfo or {}, {
					eventName = p2.eventName
				})
			end
		}
	}
})

local function fireAnalyticsEvent(p2, p3)
	if not module5 then
		return
	end

	module4.emit(telemetry, { eventName = p2, additionalInfo = p3 })
end

return fireAnalyticsEvent
