local TelemetryService = game:GetService("TelemetryService")
local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local LoggingProtocol = require(WhatsNewParent.LoggingProtocol)
local TourTipCtaAccess = require(WhatsNew.TourTipCtaAccess)

require(WhatsNew.Types)

local EventIngest = LoggingProtocol.TelemetryBackends.EventIngest
local v7 = game:DefineFastInt("WhatsNewTelemetryThrottleHundredthsPercent", 0)
local t1 = {
	tourtipInteraction = {
		eventName = "whatsNewTourtipInteraction",
		description = "Fires for tourtip impressions, clicks, dismissals, and skipped steps",
		links = "TODO: proto-schemas",
		backends = { EventIngest },
		throttlingPercentage = v7,
		lastUpdated = {
			2026,
			7,
			6
		}
	},
	tourLifecycle = {
		eventName = "whatsNewTourLifecycle",
		description = "Fires for tour session lifecycle transitions",
		links = "TODO: proto-schemas",
		backends = { EventIngest },
		throttlingPercentage = v7,
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
local t2 = {
	"addPlaceId",
	"addUniverseId",
	"addPlaySessionId"
}
local t4 = {
	Events = t1,
	buildTourContextFields = function(p1, s1: string?) -- line: 83
		-- upvalues: TourTipCtaAccess (copy)
		local currentEntry = p1.currentEntry
		local v15 = s1 or if currentEntry == nil then nil else currentEntry.id
		local t3 = {
			entry_id = v15,
			screen_scope_id = p1.screenScopeId,
			root_array = p1.activeTourType,
			global_step_index = p1.globalStepIndex,
			global_total_steps = p1.globalTotalSteps
		}

		if currentEntry ~= nil and v15 == currentEntry.id then
			t3.scope_id = currentEntry.scopeId
			t3.cta_kind = TourTipCtaAccess.wrap(currentEntry.cta):getKind()
		end

		return t3
	end
}

function t4.logTourtipInteraction(s2: string, s3: string, s4: string?, p2, s5: string?) -- line: 105
	-- upvalues: t4 (copy), TelemetryService (copy), t1 (copy), t2 (copy)
	local v22 = t4.buildTourContextFields(p2, s3)

	v22.interaction_type = s2
	v22.button = s4

	if s5 ~= nil then
		v22.skip_reason = s5
	end

	TelemetryService:LogEvent(t1.tourtipInteraction, {
		standardizedFields = t2,
		customFields = v22
	})
end
function t4.logTourLifecycle(s6: string, p3, s7: string?) -- line: 125
	-- upvalues: t4 (copy), TelemetryService (copy), t1 (copy), t2 (copy)
	local v26 = t4.buildTourContextFields(p3)

	v26.lifecycle_type = s6

	if s7 ~= nil then
		v26.stop_reason = s7
	end

	TelemetryService:LogEvent(t1.tourLifecycle, {
		standardizedFields = t2,
		customFields = v26
	})
end

return t4
