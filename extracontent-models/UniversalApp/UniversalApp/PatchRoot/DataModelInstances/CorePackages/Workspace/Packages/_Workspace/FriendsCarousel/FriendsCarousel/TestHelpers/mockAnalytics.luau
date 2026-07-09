local ParentParent = script.Parent.Parent
local TestingAnalytics = require(ParentParent.dependencies).SocialLuaAnalytics.TestingAnalytics
local mockAnalytics = TestingAnalytics.mockAnalytics
local mockLogger = TestingAnalytics.mockLogger
local setupFireEvent = require(ParentParent.Analytics).setupFireEvent

return function(t1: {[any]: any}?, t2: {[any]: any}?) -- line: 11
	-- upvalues: mockAnalytics (copy), mockLogger (copy), setupFireEvent (copy)
	local v8 = (not t1 or not t1.uid) and "123" or t1.uid
	local v9 = mockAnalytics(t2 or {
		fn = function() -- line: 13
		end
	})
	local v10 = mockLogger(t2 or {
		fn = function() -- line: 14
		end
	})
	local v11 = setupFireEvent({
		analytics = v9,
		loggerImpl = mockLogger,
		infoForAllEvents = {
			uid = v8
		}
	})

	return {
		uid = v8,
		value = {
			fireEvent = v11
		},
		mockLogger = v10,
		analyticsMock = v9
	}
end
