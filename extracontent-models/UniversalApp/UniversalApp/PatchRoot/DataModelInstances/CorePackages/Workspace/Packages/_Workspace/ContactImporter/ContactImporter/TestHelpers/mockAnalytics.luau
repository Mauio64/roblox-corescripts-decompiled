local ParentParent = script.Parent.Parent
local TestingAnalytics = require(ParentParent.dependencies).SocialLuaAnalytics.TestingAnalytics
local mockAnalytics = TestingAnalytics.mockAnalytics
local mockLogger = TestingAnalytics.mockLogger
local setupFireAnalyticsEvents = require(ParentParent.Analytics).setupFireAnalyticsEvents

return function(t1: {[any]: any}?, p1) -- line: 11
	-- upvalues: mockAnalytics (copy), mockLogger (copy), setupFireAnalyticsEvents (copy)
	local v8 = (not t1 or not t1.uid) and "123" or t1.uid
	local v9 = mockAnalytics(p1)
	local v10 = mockLogger(p1)
	local v11 = setupFireAnalyticsEvents({
		diag = v9.Diag,
		eventStreamImpl = v9.EventStream,
		loggerImpl = mockLogger,
		infoForAllEvents = {
			uid = v8
		}
	})

	return {
		uid = v8,
		value = {
			entryPoint = nil,
			fireAnalyticsEvent = v11
		},
		mockLogger = v10,
		analyticsMock = v9
	}
end
