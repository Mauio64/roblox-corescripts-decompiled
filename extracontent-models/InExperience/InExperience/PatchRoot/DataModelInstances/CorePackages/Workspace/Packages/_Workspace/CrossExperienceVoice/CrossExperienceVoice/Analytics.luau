local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CrossExperienceVoiceParent = CrossExperienceVoice.Parent
local SocialLuaAnalytics = require(CrossExperienceVoiceParent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventNames = require(script.EventNames)
local EventStreamActionList = require(script.EventStreamActionList)
local DiagActionList = require(script.DiagActionList)
local TelemetryActionList = require(script.TelemetryActionList)
local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
local t1 = {
	playSessionId = if PlaySessionId == "" then nil else PlaySessionId,
	placeId = if not (game.PlaceId > 0) then nil else tostring(game.PlaceId),
	universeId = if not (game.GameId > 0) then nil else tostring(game.GameId)
}

return {
	Analytics = AnalyticsFactory.setUpAnalyticsFactory({
		eventLists = {
			EventStream = EventStreamActionList,
			Diag = DiagActionList,
			Telemetry = TelemetryActionList
		},
		analyticsImpl = {
			EventStream = DefaultAnalyticsService.EventStream,
			Diag = DefaultAnalyticsService.Diag,
			Telemetry = DefaultAnalyticsService.Telemetry
		},
		staticInfoForAllEvents = t1
	}),
	EventNames = EventNames
}
