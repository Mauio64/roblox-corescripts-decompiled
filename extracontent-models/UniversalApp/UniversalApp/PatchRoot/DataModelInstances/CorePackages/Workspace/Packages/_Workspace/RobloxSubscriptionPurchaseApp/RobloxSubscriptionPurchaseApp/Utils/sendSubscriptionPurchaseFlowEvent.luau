local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local default = require(RobloxSubscriptionPurchaseAppParent.LoggingProtocol).default
local SubscriptionPurchaseFlowTelemetry = require(RobloxSubscriptionPurchaseApp.Events.SubscriptionPurchaseFlowTelemetry)

function sendSubscriptionPurchaseFlowEvent(t1: {[any]: any}) -- line: 7
	-- upvalues: default (copy), SubscriptionPurchaseFlowTelemetry (copy)
	default:logRobloxTelemetryEvent(SubscriptionPurchaseFlowTelemetry.SubscriptionPurchaseFlowEvent, {
		default.StandardizedFields.addOsInfo,
		default.StandardizedFields.addSessionId,
		"addSessionInfo"
	}, t1)
end

return sendSubscriptionPurchaseFlowEvent
