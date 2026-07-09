local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local t1 = {
	eventName = "ModalImpression",
	description = "Sent when a modal is shown",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("ModalImpressionThrottleHundrethsPercent", 10000),
	lastUpdated = {
		25,
		9,
		9
	}
}

return function(s1: string, s2: string) -- line: 19
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1, {
		customFields = {
			modalId = s1,
			modalType = s2
		}
	})
end
