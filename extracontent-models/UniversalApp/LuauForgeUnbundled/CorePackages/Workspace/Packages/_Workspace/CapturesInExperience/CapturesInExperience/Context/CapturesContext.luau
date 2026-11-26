local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Dash")
return require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React").createContext({
	fireAnalyticsEvent = Dash.noop,
	isZooming = false,
	navigateBack = Dash.noop,
	navigateToItemDetailPage = Dash.noop,
	navigateToReportPage = Dash.noop,
	setIsZooming = Dash.noop
})
