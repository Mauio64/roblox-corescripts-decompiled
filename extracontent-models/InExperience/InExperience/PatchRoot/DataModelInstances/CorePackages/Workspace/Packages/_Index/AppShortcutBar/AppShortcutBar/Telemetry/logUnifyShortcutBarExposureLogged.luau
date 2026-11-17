local parent = script:FindFirstAncestor("AppShortcutBar").Parent

local MockableProxyServices = require(parent.MockableProxyServices)
local TelemetryService = MockableProxyServices.TelemetryService

local v = {
	eventName = "UnifyShortcutBarExposureLoggedEvent",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 11, 11 },
	links = "proto-schemas: production/eventstream/console/unify_shortcut_bar_exposure_logged.proto",
	description = "Once per session, right before the shortcut bar calls LogFlagLinkedUserLayerExposure. Sent to ingest_proto.unify_shortcut_bar_exposure_logged."
}

local function logUnifyShortcutBarExposureLogged(sticky_bar_enabled: boolean)
	TelemetryService:LogEvent(v, {
		customFields = { sticky_bar_enabled = sticky_bar_enabled }
	})
end

return logUnifyShortcutBarExposureLogged
