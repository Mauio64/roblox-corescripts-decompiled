local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Parent = script:FindFirstAncestor("SquadsCore").Parent
local SharedFlags = require(Parent.SharedFlags)
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventNames = require(script.EventNames)
local EventStreamActionList = require(script.EventStreamActionList)
local FFlagEnableSquadCoplayAnalytic = SharedFlags.FFlagEnableSquadCoplayAnalytic
local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
local t1 = {
	playSessionId = if PlaySessionId == "" then nil else PlaySessionId,
	placeId = if not (game.PlaceId > 0) then nil else tostring(game.PlaceId),
	universeId = if not (game.GameId > 0) then nil else tostring(game.GameId),
	placeInstanceId = if game.JobId == "" then nil else tostring(game.JobId)
}

return {
	Analytics = AnalyticsFactory.setUpAnalyticsFactory({
		eventLists = {
			Diag = nil,
			EventStream = EventStreamActionList
		},
		analyticsImpl = {
			Diag = nil,
			EventStream = DefaultAnalyticsService.EventStream
		},
		staticInfoForAllEvents = t1
	}),
	EventNames = EventNames,
	logInExpCoplayTelemetry = if not FFlagEnableSquadCoplayAnalytic then nil else require(script.logInExpCoplayTelemetry)
}
