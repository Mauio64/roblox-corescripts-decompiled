local Parent = script:FindFirstAncestor("EditProfile").Parent
local EditProfileAnalyticsContext = require(script.EditProfileAnalyticsContext)
local Context = require(Parent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Context

return {
	AnalyticsService = require(script.AnalyticsService),
	Context = EditProfileAnalyticsContext,
	connect = Context.getConnect(EditProfileAnalyticsContext),
	EventNames = require(script.Enums.EventNames),
	setupFireAnalyticsEvents = require(script.setupFireAnalyticsEvents),
	useAnalytics = require(script.useAnalytics),
	AnalyticsServiceV2 = require(script.AnalyticsServiceV2)
}
