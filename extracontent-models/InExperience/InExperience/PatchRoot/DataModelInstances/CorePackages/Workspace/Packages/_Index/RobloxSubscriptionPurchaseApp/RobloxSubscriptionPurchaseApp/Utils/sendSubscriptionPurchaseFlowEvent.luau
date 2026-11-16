local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local SubscriptionPurchaseFlowTelemetry = require(RobloxSubscriptionPurchaseApp.Events.SubscriptionPurchaseFlowTelemetry)

function sendSubscriptionPurchaseFlowEvent(p)
	default:logRobloxTelemetryEvent(
		SubscriptionPurchaseFlowTelemetry.SubscriptionPurchaseFlowEvent,
		{ default.StandardizedFields.addOsInfo, default.StandardizedFields.addSessionId, "addSessionInfo" },
		p
	)
end

return sendSubscriptionPurchaseFlowEvent
