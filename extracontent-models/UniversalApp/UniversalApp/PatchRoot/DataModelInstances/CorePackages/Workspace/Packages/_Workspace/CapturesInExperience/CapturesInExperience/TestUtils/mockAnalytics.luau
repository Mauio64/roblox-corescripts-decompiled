local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local mockAnalytics = require(ParentParentParent.SocialLuaAnalytics).TestingAnalytics.mockAnalytics
local setupFireEvent = require(ParentParent.Analytics.setupFireEvent)

return function(t1: {[any]: any}?, p1) -- line: 17
	-- upvalues: mockAnalytics (copy), setupFireEvent (copy)
	local v7 = mockAnalytics(p1)
	local v8 = (not t1 or not t1.pid) and "1818" or t1.pid
	local v9 = (not t1 or not t1.source) and "mock" or t1.source
	local v10 = (not t1 or not t1.uid) and "101" or t1.uid
	local v11 = setupFireEvent({
		analytics = v7,
		infoForAllEvents = {
			isUnder13 = false,
			pid = v8,
			source = v9,
			uid = v10
		}
	})

	return {
		analyticsMock = v7,
		fireAnalyticsEvent = v11,
		uid = v10
	}
end
