local TelemetryService = game:GetService("TelemetryService")

local WhatsNew = script:FindFirstAncestor("WhatsNew")
local parent = WhatsNew.Parent

local LoggingProtocol = require(parent.LoggingProtocol)
require(WhatsNew.Types)

local EventIngest = LoggingProtocol.TelemetryBackends.EventIngest

local defineFastInt = game:DefineFastInt("WhatsNewTelemetryThrottleHundredthsPercent", 10000)

local events = {
	tourtipInteraction = {
		eventName = "whatsNewTourtipInteraction",
		backends = { EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 7, 6 },
		description = "Fires for tourtip impressions, clicks, dismissals, and skipped steps",
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/coreui/whatsnew/tourtip_interaction.proto"
	},
	tourLifecycle = {
		eventName = "whatsNewTourLifecycle",
		backends = { EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 7, 6 },
		description = "Fires for tour session lifecycle transitions",
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/coreui/whatsnew/tour_lifecycle.proto"
	}
}

local _ = {
	placeId = "addPlaceId",
	universeId = "addUniverseId",
	playsessionId = "addPlaySessionId"
}

local standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" }
local WhatsNewTelemetry = {
	Events = events,
	InteractionType = { IMPRESSION = 1, CLICK = 2, DISMISS = 3, SKIP = 4 },
	Button = { NEXT = 1, BACK = 2, CLOSE = 3 },
	SkipReason = { TOUR_ENDED_EARLY = 1 },
	LifecycleType = { TOUR_STARTED = 1, TOUR_COMPLETED = 2, TOUR_STOPPED = 3 },
	StopReason = { DISMISS = 1, ABORT = 2 },
	StartContext = { ROOT = 1, GATEWAY = 2, IDLE = 3 }
}

function WhatsNewTelemetry.buildTourSessionFields(data)
	local currentScopeTour = data.currentScopeTour
	local tourSessionFields = {
		screen_scope_id = data.screenScopeId,
		scope_id = 0,
		root_array = 0,
		global_step_index = 0,
		global_total_steps = 0
	}
	local scope_id

	if currentScopeTour ~= nil then
		scope_id = currentScopeTour.id
	end

	tourSessionFields.scope_id = scope_id
	tourSessionFields.root_array = data.activeTourType
	tourSessionFields.global_step_index = data.globalStepIndex
	tourSessionFields.global_total_steps = data.globalTotalSteps
	return tourSessionFields
end

function WhatsNewTelemetry.logTourtipInteraction(interaction_type: number, entry_id: string, button: number?, p, skip_reason: number?)
	local tourSessionFields = WhatsNewTelemetry.buildTourSessionFields(p)
	tourSessionFields.entry_id = entry_id
	tourSessionFields.interaction_type = interaction_type
	tourSessionFields.button = button

	local currentEntry = p.currentEntry

	if currentEntry ~= nil and entry_id == currentEntry.id then
		tourSessionFields.is_gateway = currentEntry.gateway ~= nil
	end

	if skip_reason ~= nil then
		tourSessionFields.skip_reason = skip_reason
	end

	TelemetryService:LogEvent(events.tourtipInteraction, {
		standardizedFields = standardizedFields,
		customFields = tourSessionFields
	})
end

function WhatsNewTelemetry.logTourLifecycle(lifecycle_type: number, p, stop_reason: number?, start_context: number?)
	local tourSessionFields = WhatsNewTelemetry.buildTourSessionFields(p)
	tourSessionFields.lifecycle_type = lifecycle_type

	if stop_reason ~= nil then
		tourSessionFields.stop_reason = stop_reason
	end

	if start_context ~= nil then
		tourSessionFields.start_context = start_context
	end

	TelemetryService:LogEvent(events.tourLifecycle, {
		standardizedFields = standardizedFields,
		customFields = tourSessionFields
	})
end

return WhatsNewTelemetry
