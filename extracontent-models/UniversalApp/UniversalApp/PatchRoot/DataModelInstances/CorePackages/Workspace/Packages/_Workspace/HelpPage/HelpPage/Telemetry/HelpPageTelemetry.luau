local TelemetryService = game:GetService("TelemetryService")
local StandardFieldEnum = require(script.Parent.StandardFieldEnum)
local v3 = game:DefineFastInt("HelpPageThrottleHundredthsPercent", 0)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 35
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end

t1.telemetryConfigs = {
	helpPageInteraction = {
		eventConfig = {
			eventName = "ingame_menu_action",
			description = "[[Event to track input type and screen orientation for the help page.]]",
			backends = { "EventIngest" },
			throttlingPercentage = v3,
			lastUpdated = {
				2025,
				8,
				25
			}
		},
		standardizedFields = {
			StandardFieldEnum.addUniverseId,
			StandardFieldEnum.addPlaySessionId,
			StandardFieldEnum.addPlaceId,
			StandardFieldEnum.addSessionInfo
		}
	}
}

function t1.logHelpPageInteraction(_: {[any]: any}, s1: string, t3: {[any]: any}) -- line: 59
	-- upvalues: t1 (copy), TelemetryService (copy)
	local eventConfig = t1.telemetryConfigs.helpPageInteraction.eventConfig
	local standardizedFields = t1.telemetryConfigs.helpPageInteraction.standardizedFields

	TelemetryService:LogEvent(eventConfig, {
		eventContext = s1,
		standardizedFields = standardizedFields,
		customFields = t3
	})
end

t1.default = t1.new()

return t1
