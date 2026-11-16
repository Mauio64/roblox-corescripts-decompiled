local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local parent = CrossExperienceVoice.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EventNames = require(script.EventNames)
local EventStreamActionList = require(script.EventStreamActionList)
local DiagActionList = require(script.DiagActionList)
local TelemetryActionList = require(script.TelemetryActionList)

local playSessionId = RbxAnalyticsService:GetPlaySessionId()

if playSessionId == "" then
	playSessionId = nil
end

local placeId

if game.PlaceId > 0 then
	placeId = tostring(game.PlaceId)
end

local universeId

if game.GameId > 0 then
	universeId = tostring(game.GameId)
end

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
		staticInfoForAllEvents = {
			playSessionId = playSessionId,
			placeId = placeId,
			universeId = universeId
		}
	}),
	EventNames = EventNames
}
