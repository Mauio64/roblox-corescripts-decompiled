local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/LoggingProtocol")

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local WizardEventNames = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/WizardEventNames")

local defineFastInt = game:DefineFastInt("AmpV2WizardEventThrottleHundredthsPercent", 10000)

local function flattenParams(items)
	local result = {}

	if items == nil then
		return result
	end

	for k, item in items do
		local typeName = type(item)

		if typeName == "string" or typeName == "number" or typeName == "boolean" then
			result[k] = item
		end
	end

	return result
end

local function makeConfig(p2)
	return {
		eventName = p2,
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 8, 19 },
		description = "AMP v2 wizard funnel events"
	}
end

local v5 = {
	flattenParams = flattenParams,
	createSendWizardEvent = function(object)
		return function(p2, p3)
			object:logRobloxTelemetryEvent(makeConfig(p2), nil, flattenParams(p3), WizardEventNames.CONTEXT)
		end
	end,
	default = 0
}

local default = LoggingProtocol.default

function v5.default(p2, p3)
	default:logRobloxTelemetryEvent(makeConfig(p2), nil, flattenParams(p3), WizardEventNames.CONTEXT)
end
return v5
