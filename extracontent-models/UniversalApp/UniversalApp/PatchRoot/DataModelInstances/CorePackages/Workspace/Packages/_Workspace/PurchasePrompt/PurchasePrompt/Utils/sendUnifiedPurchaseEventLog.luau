local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local default = require(PurchasePromptParent.LoggingProtocol).default
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)

function sendUnifiedPurchaseEventLog(p1) -- line: 7
	-- upvalues: default (copy), UnifiedPurchaseTelemetry (copy)
	default:logRobloxTelemetryEvent(UnifiedPurchaseTelemetry.UnifiedProductPurchaseFlowEvent, {
		default.StandardizedFields.addOsInfo,
		default.StandardizedFields.addSessionId,
		"addSessionInfo"
	}, p1)
end

return sendUnifiedPurchaseEventLog
