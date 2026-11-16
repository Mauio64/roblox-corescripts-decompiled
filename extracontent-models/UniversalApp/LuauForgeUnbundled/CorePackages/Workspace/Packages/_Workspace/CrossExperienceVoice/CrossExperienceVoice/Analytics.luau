local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/SocialLuaAnalytics")

local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Analytics/EventNames")
local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Analytics/EventStreamActionList")
local DiagActionList = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Analytics/DiagActionList")
local TelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Analytics/TelemetryActionList")

local playSessionId = RbxAnalyticsService:GetPlaySessionId()

if playSessionId == "" then
	playSessionId = nil
end

local v6 = if game.PlaceId > 0 then tostring(game.PlaceId) else nil
local v7 = if game.GameId > 0 then tostring(game.GameId) else nil
return {
	Analytics = analyticsFactory.setUpAnalyticsFactory({
		eventLists = { EventStream = EventStreamActionList, Diag = DiagActionList, Telemetry = TelemetryActionList },
		analyticsImpl = {
			EventStream = defaultAnalyticsService.EventStream,
			Diag = defaultAnalyticsService.Diag,
			Telemetry = defaultAnalyticsService.Telemetry
		},
		staticInfoForAllEvents = {
			playSessionId = playSessionId,
			placeId = v6,
			universeId = v7
		}
	}),
	EventNames = module2
}
