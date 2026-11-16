local parent = script:FindFirstAncestor("EditProfile").Parent
local EditProfileAnalyticsContext = require(script.EditProfileAnalyticsContext)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local context = LuaSocialLibrariesDeps.SocialLibraries.config({}).Context

return {
	AnalyticsService = require(script.AnalyticsService),
	Context = EditProfileAnalyticsContext,
	connect = context.getConnect(EditProfileAnalyticsContext),
	EventNames = require(script.Enums.EventNames),
	setupFireAnalyticsEvents = require(script.setupFireAnalyticsEvents),
	useAnalytics = require(script.useAnalytics),
	AnalyticsServiceV2 = require(script.AnalyticsServiceV2)
}
