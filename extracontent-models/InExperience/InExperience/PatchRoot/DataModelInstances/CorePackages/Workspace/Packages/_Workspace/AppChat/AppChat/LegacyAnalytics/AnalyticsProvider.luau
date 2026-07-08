local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Roact = require(AppChatParent.Roact)
local Analytics = require(AppChatParent.Analytics).Analytics
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RoactChatAnalytics = require(script.Parent.RoactChatAnalytics)
local AnalyticsContext = require(AppChat.LegacyAnalytics.AnalyticsContext)

return function(t1: {[any]: any}) -- line: 17
	-- upvalues: Analytics (copy), RbxAnalyticsService (copy), Roact (copy), AnalyticsContext (copy), RoactChatAnalytics (copy)
	local v9 = Analytics.new(RbxAnalyticsService)

	return Roact.createElement(AnalyticsContext.Provider, {
		value = RoactChatAnalytics.new(v9, t1.localUserId)
	}, Roact.oneChild(t1[Roact.Children]))
end
