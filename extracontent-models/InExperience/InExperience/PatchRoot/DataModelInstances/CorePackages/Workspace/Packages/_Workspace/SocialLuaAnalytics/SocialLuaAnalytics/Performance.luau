local Parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent

return {
	createScrollIntervalTracker = require(Parent.ScrollIntervalTracker).createScrollIntervalTracker
}
