local parent = script:FindFirstAncestor("AuthCommon").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

game:DefineFastInt("LoginByUsernameSSOErrorsThrottleHundrethsPercent", 0)

return {
	eventName = "LoginByUsernameSSOErrors",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:GetFastInt("LoginByUsernameSSOErrorsThrottleHundrethsPercent"),
	lastUpdated = { 24, 5, 3 },
	description = "Report LoginByUsernameSSO Error codes to Points with document name \"loginbyusernamessoerrors\""
}
