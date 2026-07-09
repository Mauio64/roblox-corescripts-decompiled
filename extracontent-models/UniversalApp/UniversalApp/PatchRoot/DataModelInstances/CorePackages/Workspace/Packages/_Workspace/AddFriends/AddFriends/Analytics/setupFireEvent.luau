local Parent = script:FindFirstAncestor("AddFriends").Parent
local createFireEvent = require(Parent.SocialLuaAnalytics).Analytics.FireEvent.createFireEvent
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local TelemetryActionList = require(script.Parent.TelemetryActionList)

return (createFireEvent({
	EventStream = EventStreamActionList,
	Telemetry = TelemetryActionList
}))
