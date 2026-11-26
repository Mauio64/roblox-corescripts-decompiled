return {
	eventName = "accountSecurityChallengeRoCaptchaEvent",
	backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/LoggingProtocol").TelemetryBackends.EventIngest },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 10, 27 },
	description = "Tracks lifecycle events for the RoCaptcha GCS challenge",
	links = "https://docs.google.com/document/d/10lZvtSW6yN8uhNzo6628hYpHi_61YeHrGxjaqWum6Ko"
}
