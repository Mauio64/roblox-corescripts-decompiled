local TelemetryService = game:GetService("TelemetryService")

local module = require("@luauforge/deferred/elf")

local function AnalyticsSetup(p2)
	local infoForAllEvents = p2 and p2.infoForAllEvents or {}
	local telemetryServiceImpl = p2 and p2.telemetryServiceImpl or TelemetryService

	return {
		fireAnalyticsEvent = function(p3, options)
			local event = module.Events[p3]

			if event == nil then
				return
			end

			local tileFields = module.buildTileFields(options or {}, infoForAllEvents)

			telemetryServiceImpl:LogCounter(event.counter, { customFields = tileFields }, 1)

			telemetryServiceImpl:LogEvent(event.eventIngest, {
				eventContext = module.Ctx,
				standardizedFields = { "addSessionInfo" },
				customFields = tileFields
			})
		end
	}
end

return AnalyticsSetup
