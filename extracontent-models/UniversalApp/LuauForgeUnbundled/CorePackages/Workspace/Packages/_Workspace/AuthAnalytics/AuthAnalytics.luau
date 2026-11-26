return {
	dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/dependencies"),
	Events = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Events"),
	EventStreamConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Constants/EventStreamConstants"),
	LoginType = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Constants/LoginType"),
	authTimingUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/authTimingUtil"),
	TelemetryConfigs = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/RobloxTelemetry/TelemetryConfigs"),
	RobloxTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/RobloxTelemetry"),
	Flags = {
		FFlagEnableTimeToLoginMetrics = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Flags/FFlagEnableTimeToLoginMetrics"),
		FFlagRestartTimeToLoginOnHumanInteractionRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Flags/FFlagRestartTimeToLoginOnHumanInteractionRetry")
	}
}
