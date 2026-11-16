local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Roact = require(parent.Roact)
local Analytics = require(parent.Analytics)
local analytics = Analytics.Analytics
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RoactChatAnalytics = require(script.Parent.RoactChatAnalytics)

local AnalyticsContext = require(AppChat.LegacyAnalytics.AnalyticsContext)

return function(props)
	local v = analytics.new(RbxAnalyticsService)

	return Roact.createElement(
		AnalyticsContext.Provider,
		{
			value = RoactChatAnalytics.new(v, props.localUserId)
		},
		Roact.oneChild(props[Roact.Children])
	)
end
