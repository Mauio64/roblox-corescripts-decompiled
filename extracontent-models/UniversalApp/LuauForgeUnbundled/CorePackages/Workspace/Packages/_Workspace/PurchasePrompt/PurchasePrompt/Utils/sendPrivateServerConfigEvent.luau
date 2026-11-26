local default = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol").default

local VIPServerPostPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/VIPServerPostPurchaseTelemetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local function sendPrivateServerConfigEvent(p2)
	default:logRobloxTelemetryEvent(
		VIPServerPostPurchaseTelemetry.PrivateServerConfigEvent,
		{ default.StandardizedFields.addOsInfo, default.StandardizedFields.addSessionId, "addSessionInfo" },
		p2
	)
end

return sendPrivateServerConfigEvent
