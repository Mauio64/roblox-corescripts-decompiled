local TelemetryService = game:GetService("TelemetryService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModalImpressions/LoggingProtocol")

local defineFastFlag = game:DefineFastFlag("ModalImpressionEventAddSessionInfo", false)

local v5 = {
	eventName = "ModalImpression",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("ModalImpressionThrottleHundrethsPercent", 10000),
	lastUpdated = { 25, 9, 9 },
	description = "Sent when a modal is shown",
	links = ""
}

return function(p2, p3)
	TelemetryService:LogEvent(v5, {
		standardizedFields = defineFastFlag and { "addSessionInfo" } or nil,
		customFields = { modalId = p2, modalType = p3 }
	})
end
