local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local socialLuaAnalytics = dependencies.SocialLuaAnalytics

local DiagActionList = require(script.Parent.DiagActionList)
local EventStreamActionList = require(script.Parent.EventStreamActionList)
return socialLuaAnalytics.Analytics.FireEvent.createFireEvent({
	EventStream = EventStreamActionList,
	Diag = DiagActionList
})
