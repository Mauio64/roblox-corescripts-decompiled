local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)

function sendUnifiedPurchaseEventLog(p)
	default:logRobloxTelemetryEvent(
		UnifiedPurchaseTelemetry.UnifiedProductPurchaseFlowEvent,
		{ default.StandardizedFields.addOsInfo, default.StandardizedFields.addSessionId, "addSessionInfo" },
		p
	)
end

return sendUnifiedPurchaseEventLog
