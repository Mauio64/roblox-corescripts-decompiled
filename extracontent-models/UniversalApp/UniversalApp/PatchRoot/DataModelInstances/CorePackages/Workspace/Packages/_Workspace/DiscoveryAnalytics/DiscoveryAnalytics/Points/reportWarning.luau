local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local default = LoggingProtocol.default
local v5 = game:DefineFastInt("DiscoveryWarningEventHundredthsPercent", 0)
local t1 = {
	eventName = "DiscoveryWarning",
	description = "Generic warning message for Discovery surfaces",
	links = "",
	backends = { default.TelemetryBackends.Points },
	throttlingPercentage = v5,
	lastUpdated = {
		25,
		1,
		22
	}
}
local t2 = {
	eventName = "DiscoveryWarningCounter",
	throttlingPercentage = 0,
	description = "Counter for the total number of warnings sent",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		1,
		22
	}
}

local function reportWarning(p1, s1: string, s2: string, t3: {[any]: any}?) -- line: 31
	-- upvalues: RunService (copy), t2 (copy), t1 (copy)
	local v13 = t3 and table.clone(t3) or {}

	v13.category = s1
	v13.extraMessage = s2

	if RunService:IsStudio() or (_G.__TESTEZ_RUNNING_TEST__ or _G.__TEST_SUITE_PACKAGE__) then
		warn(`DiscoveryWarning: [{ s1 }] { s2 }`)
	end

	p1:logRobloxTelemetryCounter(t2, 1, {
		category = s1
	})
	p1:logRobloxTelemetryEvent(t1, { p1.StandardizedFields.addOsInfo }, v13)
end

return reportWarning
