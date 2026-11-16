local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("ServerTriggeredModalImpressions").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local defineFastFlag = game:DefineFastFlag("ModalImpressionEventAddSessionInfo", false)

local v = {
	eventName = "ModalImpression",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("ModalImpressionThrottleHundrethsPercent", 10000),
	lastUpdated = { 25, 9, 9 },
	description = "Sent when a modal is shown",
	links = ""
}

return function(modalId: string, modalType: string)
	TelemetryService:LogEvent(v, {
		standardizedFields = defineFastFlag and { "addSessionInfo" } or nil,
		customFields = { modalId = modalId, modalType = modalType }
	})
end
