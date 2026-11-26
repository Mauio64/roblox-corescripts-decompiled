local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/LoggingProtocol")

game:DefineFastInt("LoginByEmailSSOErrorsThrottleHundrethsPercent", 0)

return {
	eventName = "LoginByEmailSSOErrors",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:GetFastInt("LoginByEmailSSOErrorsThrottleHundrethsPercent"),
	lastUpdated = { 26, 10, 5 },
	description = "Report LoginByEmail SSO error codes to Points with document name \"loginbyemailssoerrors\""
}
