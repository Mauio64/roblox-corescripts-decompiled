local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SocialLuaAnalytics")

local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")
local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventStreamActionList")

local playSessionId = RbxAnalyticsService:GetPlaySessionId()

if playSessionId == "" then
	playSessionId = nil
end

local v6 = if game.PlaceId > 0 then tostring(game.PlaceId) else nil
local v7 = if game.GameId > 0 then tostring(game.GameId) else nil
local v8 = if game.JobId ~= "" then tostring(game.JobId) else nil
return {
	Analytics = analyticsFactory.setUpAnalyticsFactory({
		eventLists = { EventStream = EventStreamActionList, Diag = nil },
		analyticsImpl = {
			EventStream = defaultAnalyticsService.EventStream,
			Diag = nil
		},
		staticInfoForAllEvents = {
			playSessionId = playSessionId,
			placeId = v6,
			universeId = v7,
			placeInstanceId = v8
		}
	}),
	EventNames = module2,
	logInExpCoplayTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/logInExpCoplayTelemetry")
}
