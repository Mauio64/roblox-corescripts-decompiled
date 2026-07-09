local ParentParent = script.Parent.Parent
local SocialLuaAnalytics = require(ParentParent.dependencies).SocialLuaAnalytics
local DiagActionList = require(script.Parent.DiagActionList)
local EventStreamActionList = require(script.Parent.EventStreamActionList)

return SocialLuaAnalytics.Analytics.FireEvent.createFireEvent({
	EventStream = EventStreamActionList,
	Diag = DiagActionList
})
