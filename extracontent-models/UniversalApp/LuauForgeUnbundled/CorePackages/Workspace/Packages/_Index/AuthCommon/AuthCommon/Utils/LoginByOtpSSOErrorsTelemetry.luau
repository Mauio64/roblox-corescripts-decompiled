local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/LoggingProtocol")

game:DefineFastInt("LoginByOtpSSOErrorsThrottleHundrethsPercent", 0)

return {
	eventName = "LoginByOtpSSOErrors",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:GetFastInt("LoginByOtpSSOErrorsThrottleHundrethsPercent"),
	lastUpdated = { 26, 10, 20 },
	description = "Report LoginByOtp SSO error codes to Points with document name \"loginbyotpssoerrors\""
}
