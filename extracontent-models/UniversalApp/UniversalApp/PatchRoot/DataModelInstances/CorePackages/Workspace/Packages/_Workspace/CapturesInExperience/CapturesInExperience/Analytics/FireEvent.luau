local ParentParent = script.Parent.Parent
local Players = game:GetService("Players")
local AnalyticsService = require(ParentParent.Analytics.AnalyticsService)
local Constants = require(ParentParent.Constants)
local getLocalUserId = require(ParentParent.Utils.getLocalUserId)

return (require(ParentParent.Analytics.setupFireEvent)({
	analytics = AnalyticsService,
	infoForAllEvents = {
		isUnder13 = if not Players.LocalPlayer then nil else Players.LocalPlayer:GetUnder13(),
		pid = tostring(game.PlaceId),
		source = Constants.AnalyticsSource,
		uid = getLocalUserId(Players)
	}
}))
