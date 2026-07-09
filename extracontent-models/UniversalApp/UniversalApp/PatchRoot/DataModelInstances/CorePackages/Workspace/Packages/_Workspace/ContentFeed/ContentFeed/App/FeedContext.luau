local ParentParent = script.Parent.Parent.Parent
local Dash = require(ParentParent.Dash)

return require(ParentParent.React).createContext({
	isZooming = false,
	fireAnalyticsEvent = Dash.noop,
	navigateBack = Dash.noop,
	navigateToItemDetailPage = Dash.noop,
	navigateToReportPage = Dash.noop,
	setIsZooming = Dash.noop
})
