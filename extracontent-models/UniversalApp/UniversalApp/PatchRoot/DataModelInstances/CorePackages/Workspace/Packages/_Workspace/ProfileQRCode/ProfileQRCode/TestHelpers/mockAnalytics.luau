local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local TestingAnalytics = require(ProfileQRCodeParent.SocialLuaAnalytics).TestingAnalytics
local mockAnalytics = TestingAnalytics.mockAnalytics
local mockLogger = TestingAnalytics.mockLogger
local setupFireEvent = require(ProfileQRCode.Analytics).setupFireEvent

return function(t1: {[any]: any}?, p1) -- line: 10
	-- upvalues: mockAnalytics (copy), mockLogger (copy), setupFireEvent (copy)
	local v9 = (not t1 or not t1.uid) and "123" or t1.uid
	local v10 = mockAnalytics(p1)
	local v11 = mockLogger(p1)
	local v12 = setupFireEvent({
		analytics = v10,
		loggerImpl = mockLogger,
		infoForAllEvents = {
			uid = v9
		}
	})

	return {
		uid = v9,
		value = {
			fireEvent = v12
		},
		mockLogger = v11,
		analyticsMock = v10
	}
end
