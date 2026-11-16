local RunService = game:GetService("RunService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local defineFastInt = game:DefineFastInt("DiscoveryWarningEventHundredthsPercent", 0)

local v = {
	eventName = "DiscoveryWarning",
	backends = { default.TelemetryBackends.Points },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 1, 22 },
	description = "Generic warning message for Discovery surfaces",
	links = ""
}

local v2 = {
	eventName = "DiscoveryWarningCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = 0,
	lastUpdated = { 25, 1, 22 },
	description = "Counter for the total number of warnings sent"
}

local function reportWarning(object, category: string, extraMessage: string, p)
	local clone = p and table.clone(p) or {}
	clone.category = category
	clone.extraMessage = extraMessage

	if RunService:IsStudio() or _G.__TESTEZ_RUNNING_TEST__ or _G.__TEST_SUITE_PACKAGE__ then
		warn(`DiscoveryWarning: [{category}] {extraMessage}`)
	end

	object:logRobloxTelemetryCounter(v2, 1, { category = category })

	object:logRobloxTelemetryEvent(v, { object.StandardizedFields.addOsInfo }, clone)
end

return reportWarning
