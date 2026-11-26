local telemetryService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/MockableProxyServices").TelemetryService

local v5 = {
	eventName = "UnifyShortcutBarExposureLoggedEvent",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 11, 11 },
	links = "proto-schemas: production/eventstream/console/unify_shortcut_bar_exposure_logged.proto",
	description = "Once per session, right before the shortcut bar calls LogFlagLinkedUserLayerExposure. Sent to ingest_proto.unify_shortcut_bar_exposure_logged."
}

local function logUnifyShortcutBarExposureLogged(p2)
	telemetryService:LogEvent(v5, {
		customFields = { sticky_bar_enabled = p2 }
	})
end

return logUnifyShortcutBarExposureLogged
