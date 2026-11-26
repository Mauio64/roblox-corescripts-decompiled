local RunService = game:GetService("RunService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/LoggingProtocol")
local default = LoggingProtocol.default

local defineFastInt = game:DefineFastInt("DiscoveryWarningEventHundredthsPercent", 0)

local v5 = {
	eventName = "DiscoveryWarning",
	backends = { default.TelemetryBackends.Points },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 1, 22 },
	description = "Generic warning message for Discovery surfaces",
	links = ""
}

local v6 = {
	eventName = "DiscoveryWarningCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = 0,
	lastUpdated = { 25, 1, 22 },
	description = "Counter for the total number of warnings sent"
}

local function reportWarning(object, category, extraMessage, p2)
	local clone = p2 and table.clone(p2) or {}
	clone.category = category
	clone.extraMessage = extraMessage

	if RunService:IsStudio() or _G.__TESTEZ_RUNNING_TEST__ or _G.__TEST_SUITE_PACKAGE__ then
		warn(`DiscoveryWarning: [{category}] {extraMessage}`)
	end

	object:logRobloxTelemetryCounter(v6, 1, { category = category })

	object:logRobloxTelemetryEvent(v5, { object.StandardizedFields.addOsInfo }, clone)
end

return reportWarning
