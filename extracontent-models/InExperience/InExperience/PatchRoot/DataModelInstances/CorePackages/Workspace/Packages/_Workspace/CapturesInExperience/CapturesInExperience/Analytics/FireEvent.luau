local parent = script.Parent.Parent

local Players = game:GetService("Players")

local AnalyticsService = require(parent.Analytics.AnalyticsService)
local Constants = require(parent.Constants)
local getLocalUserId = require(parent.Utils.getLocalUserId)
local setupFireEvent = require(parent.Analytics.setupFireEvent)
local isUnder

if Players.LocalPlayer then
	isUnder = Players.LocalPlayer:GetUnder13()
end

return (setupFireEvent({
	analytics = AnalyticsService,
	infoForAllEvents = {
		isUnder13 = isUnder,
		pid = tostring(game.PlaceId),
		source = Constants.AnalyticsSource,
		uid = getLocalUserId(Players)
	}
}))
