local TelemetryService = game:GetService("TelemetryService")
local StandardFieldEnum = require(script.Parent.StandardFieldEnum)

local defineFastInt = game:DefineFastInt("HelpPageThrottleHundredthsPercent", 0)

local HelpPageTelemetry = {}
HelpPageTelemetry.__index = HelpPageTelemetry

function HelpPageTelemetry.new()
	return (setmetatable({}, HelpPageTelemetry))
end

HelpPageTelemetry.telemetryConfigs = {
	helpPageInteraction = {
		eventConfig = {
			eventName = "ingame_menu_action",
			backends = { "EventIngest" },
			throttlingPercentage = defineFastInt,
			lastUpdated = { 2025, 8, 25 },
			description = "[[Event to track input type and screen orientation for the help page.]]"
		},
		standardizedFields = {
			StandardFieldEnum.addUniverseId,
			StandardFieldEnum.addPlaySessionId,
			StandardFieldEnum.addPlaceId,
			StandardFieldEnum.addSessionInfo
		}
	}
}

function HelpPageTelemetry.logHelpPageInteraction(_, eventContext: string, customFields)
	TelemetryService:LogEvent(HelpPageTelemetry.telemetryConfigs.helpPageInteraction.eventConfig, {
		eventContext = eventContext,
		standardizedFields = HelpPageTelemetry.telemetryConfigs.helpPageInteraction.standardizedFields,
		customFields = customFields
	})
end

HelpPageTelemetry.default = HelpPageTelemetry.new()
return HelpPageTelemetry
