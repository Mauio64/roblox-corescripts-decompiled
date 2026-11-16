local parent = script:FindFirstAncestor("AuthCommon").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

game:DefineFastInt("LoginByOtpSSOErrorsThrottleHundrethsPercent", 0)

return {
	eventName = "LoginByOtpSSOErrors",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:GetFastInt("LoginByOtpSSOErrorsThrottleHundrethsPercent"),
	lastUpdated = { 26, 10, 20 },
	description = "Report LoginByOtp SSO error codes to Points with document name \"loginbyotpssoerrors\""
}
