local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local parent = script:FindFirstAncestor("SquadsCore").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EventNames = require(script.EventNames)
local EventStreamActionList = require(script.EventStreamActionList)

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

local placeInstanceId

if game.JobId ~= "" then
	placeInstanceId = tostring(game.JobId)
end

return {
	Analytics = AnalyticsFactory.setUpAnalyticsFactory({
		eventLists = { EventStream = EventStreamActionList, Diag = nil },
		analyticsImpl = { EventStream = DefaultAnalyticsService.EventStream, Diag = nil },
		staticInfoForAllEvents = {
			playSessionId = playSessionId,
			placeId = placeId,
			universeId = universeId,
			placeInstanceId = placeInstanceId
		}
	}),
	EventNames = EventNames,
	logInExpCoplayTelemetry = require(script.logInExpCoplayTelemetry)
}
