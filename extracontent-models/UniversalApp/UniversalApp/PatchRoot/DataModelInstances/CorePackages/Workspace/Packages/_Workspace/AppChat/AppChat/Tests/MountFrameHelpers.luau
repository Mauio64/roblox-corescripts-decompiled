local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local UnitTestHelpers = require(AppChatParent.Dev.UnitTestHelpers)
local mountFrame = UnitTestHelpers.mountFrame
local mountStyledFrame = UnitTestHelpers.mountStyledFrame
local mockAnalytics = require(AppChat.LegacyAnalytics.Mock.mockAnalytics)
local mockApolloProvider = require(script.Parent.mockApolloProvider)
local mockTopBar = require(script.Parent.mockTopBar)

return {
	mountFrameWithApollo = function(p1, p2) -- line: 13
		-- upvalues: mountFrame (copy), mockApolloProvider (copy), mockAnalytics (copy)
		return mountFrame(mockApolloProvider(mockAnalytics(p1)), p2)
	end,
	mountFrame = mountFrame,
	mountStyledFrame = function(p3, p4) -- line: 17
		-- upvalues: mountStyledFrame (copy), mockAnalytics (copy)
		return mountStyledFrame(mockAnalytics(p3), p4)
	end,
	mountFrameWithAnalytics = function(p5, p6) -- line: 20
		-- upvalues: mountFrame (copy), mockAnalytics (copy)
		return mountFrame(mockAnalytics(p5), p6)
	end,
	mountFrameWithTopBar = function(p7, p8) -- line: 23
		-- upvalues: mountFrame (copy), mockApolloProvider (copy), mockAnalytics (copy), mockTopBar (copy)
		return mountFrame(mockApolloProvider(mockAnalytics(mockTopBar(p7))), p8)
	end
}
