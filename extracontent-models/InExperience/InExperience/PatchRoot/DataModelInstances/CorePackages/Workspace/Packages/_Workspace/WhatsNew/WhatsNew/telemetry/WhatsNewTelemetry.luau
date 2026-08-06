local TelemetryService = game:GetService("TelemetryService")
local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local LoggingProtocol = require(WhatsNewParent.LoggingProtocol)

require(WhatsNew.Types)

local EventIngest = LoggingProtocol.TelemetryBackends.EventIngest
local v6 = game:DefineFastInt("WhatsNewTelemetryThrottleHundredthsPercent", 10000)
local t1 = {
	IMPRESSION = 1,
	CLICK = 2,
	DISMISS = 3,
	SKIP = 4
}
local t2 = {
	NEXT = 1,
	BACK = 2,
	CLOSE = 3
}
local t3 = {
	TOUR_ENDED_EARLY = 1
}
local t4 = {
	TOUR_STARTED = 1,
	TOUR_COMPLETED = 2,
	TOUR_STOPPED = 3
}
local t5 = {
	DISMISS = 1,
	ABORT = 2
}
local t6 = {
	ROOT = 1,
	GATEWAY = 2,
	IDLE = 3
}
local t7 = {
	tourtipInteraction = {
		eventName = "whatsNewTourtipInteraction",
		description = "Fires for tourtip impressions, clicks, dismissals, and skipped steps",
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/coreui/whatsnew/tourtip_interaction.proto",
		backends = { EventIngest },
		throttlingPercentage = v6,
		lastUpdated = {
			2026,
			7,
			6
		}
	},
	tourLifecycle = {
		eventName = "whatsNewTourLifecycle",
		description = "Fires for tour session lifecycle transitions",
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/coreui/whatsnew/tour_lifecycle.proto",
		backends = { EventIngest },
		throttlingPercentage = v6,
		lastUpdated = {
			2026,
			7,
			6
		}
	}
}
local _ = {
	placeId = "addPlaceId",
	universeId = "addUniverseId",
	playsessionId = "addPlaySessionId"
}
local t8 = {
	"addPlaceId",
	"addUniverseId",
	"addPlaySessionId"
}
local t9 = {
	Events = t7,
	InteractionType = t1,
	Button = t2,
	SkipReason = t3,
	LifecycleType = t4,
	StopReason = t5,
	StartContext = t6,
	buildTourSessionFields = function(p1) -- line: 122
		local currentScopeTour = p1.currentScopeTour

		return {
			screen_scope_id = p1.screenScopeId,
			scope_id = if currentScopeTour == nil then nil else currentScopeTour.id,
			root_array = p1.activeTourType,
			global_step_index = p1.globalStepIndex,
			global_total_steps = p1.globalTotalSteps
		}
	end
}

function t9.logTourtipInteraction(n1: number, s1: string, n2: number?, p2, n3: number?) -- line: 133
	-- upvalues: t9 (copy), TelemetryService (copy), t7 (copy), t8 (copy)
	local v24 = t9.buildTourSessionFields(p2)

	v24.entry_id = s1
	v24.interaction_type = n1
	v24.button = n2

	local currentEntry = p2.currentEntry

	if currentEntry ~= nil and s1 == currentEntry.id then
		v24.is_gateway = currentEntry.gateway ~= nil
	end

	if n3 ~= nil then
		v24.skip_reason = n3
	end

	TelemetryService:LogEvent(t7.tourtipInteraction, {
		standardizedFields = t8,
		customFields = v24
	})
end
function t9.logTourLifecycle(n4: number, p3, n5: number?, n6: number?) -- line: 160
	-- upvalues: t9 (copy), TelemetryService (copy), t7 (copy), t8 (copy)
	local v30 = t9.buildTourSessionFields(p3)

	v30.lifecycle_type = n4

	if n5 ~= nil then
		v30.stop_reason = n5
	end

	if n6 ~= nil then
		v30.start_context = n6
	end

	TelemetryService:LogEvent(t7.tourLifecycle, {
		standardizedFields = t8,
		customFields = v30
	})
end

return t9
