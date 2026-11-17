local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local LoggingProtocol = require(parent.LoggingProtocol)

require(AmpV2Wizard.Types)
local WizardEventNames = require(AmpV2Wizard.WizardEventNames)

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

local function makeConfig(eventName: string)
	return {
		eventName = eventName,
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 8, 19 },
		description = "AMP v2 wizard funnel events"
	}
end

local WizardAnalytics = {
	flattenParams = flattenParams,
	createSendWizardEvent = function(object)
		return function(eventName: string, p)
			object:logRobloxTelemetryEvent(makeConfig(eventName), nil, flattenParams(p), WizardEventNames.CONTEXT)
		end
	end,
	default = 0
}

local default = LoggingProtocol.default

function WizardAnalytics.default(eventName: string, p)
	default:logRobloxTelemetryEvent(makeConfig(eventName), nil, flattenParams(p), WizardEventNames.CONTEXT)
end
return WizardAnalytics
