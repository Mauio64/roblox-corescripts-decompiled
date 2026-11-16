local default = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/LoggingProtocol").default

local SubscriptionPurchaseFlowTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Events/SubscriptionPurchaseFlowTelemetry")

function LUAUFORGE_MODULE_GLOBALS_aPd_sendSubscriptionPurchaseFlowEvent(p2)
	default:logRobloxTelemetryEvent(
		SubscriptionPurchaseFlowTelemetry.SubscriptionPurchaseFlowEvent,
		{ default.StandardizedFields.addOsInfo, default.StandardizedFields.addSessionId, "addSessionInfo" },
		p2
	)
end

return LUAUFORGE_MODULE_GLOBALS_aPd_sendSubscriptionPurchaseFlowEvent
