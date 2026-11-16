return {
	Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/Analytics"),
	AnalyticsReporters = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/AnalyticsReporters"),
	getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/getPlatformTarget"),
	ReportToDiagByCountryCode = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/ReportToDiagByCountryCode"),
	RequestTimeDiag = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/RequestTimeDiag"),
	Events = {
		pageHeartbeat = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/Events/pageHeartbeat"),
		userInteractions = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/Events/userInteractions")
	}
}
