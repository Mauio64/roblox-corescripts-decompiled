local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Analytics").Analytics
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RoactChatAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/RoactChatAnalytics")

local AnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/AnalyticsContext")

return function(props)
	local v5 = analytics.new(RbxAnalyticsService)

	return Roact.createElement(
		AnalyticsContext.Provider,
		{
			value = RoactChatAnalytics.new(v5, props.localUserId)
		},
		Roact.oneChild(props[Roact.Children])
	)
end
