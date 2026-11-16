local parent = script:FindFirstAncestor("AuthCommon").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

game:DefineFastInt("LoginByPhoneSSOErrorsThrottleHundrethsPercent", 0)

return {
	eventName = "LoginByPhoneSSOErrors",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:GetFastInt("LoginByPhoneSSOErrorsThrottleHundrethsPercent"),
	lastUpdated = { 26, 10, 5 },
	description = "Report LoginByPhoneSSO Error codes to Points with document name \"loginbyphonessoerrors\""
}
