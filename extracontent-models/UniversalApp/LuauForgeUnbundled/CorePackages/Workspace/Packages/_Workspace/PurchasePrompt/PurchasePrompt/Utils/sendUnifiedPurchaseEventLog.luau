local default = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol").default

local UnifiedPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/UnifiedPurchaseTelemetry")

function LUAUFORGE_MODULE_GLOBALS_beE_sendUnifiedPurchaseEventLog(p2)
	default:logRobloxTelemetryEvent(
		UnifiedPurchaseTelemetry.UnifiedProductPurchaseFlowEvent,
		{ default.StandardizedFields.addOsInfo, default.StandardizedFields.addSessionId, "addSessionInfo" },
		p2
	)
end

return LUAUFORGE_MODULE_GLOBALS_beE_sendUnifiedPurchaseEventLog
