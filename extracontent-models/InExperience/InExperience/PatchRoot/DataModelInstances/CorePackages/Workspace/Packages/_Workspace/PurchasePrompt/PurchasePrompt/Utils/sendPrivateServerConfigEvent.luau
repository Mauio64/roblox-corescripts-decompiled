local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local VIPServerPostPurchaseTelemetry = require(PurchasePrompt.Events.VIPServerPostPurchaseTelemetry)
require(PurchasePrompt.types)

local function sendPrivateServerConfigEvent(p)
	default:logRobloxTelemetryEvent(
		VIPServerPostPurchaseTelemetry.PrivateServerConfigEvent,
		{ default.StandardizedFields.addOsInfo, default.StandardizedFields.addSessionId, "addSessionInfo" },
		p
	)
end

return sendPrivateServerConfigEvent
