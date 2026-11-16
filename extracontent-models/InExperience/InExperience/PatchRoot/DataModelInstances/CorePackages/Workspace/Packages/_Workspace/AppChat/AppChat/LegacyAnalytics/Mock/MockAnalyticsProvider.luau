local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)
local Analytics = require(parent.Analytics)
local analytics = Analytics.Analytics
local RoactChatAnalytics = require(script.Parent.Parent.RoactChatAnalytics)
local AnalyticsContext = require(script.Parent.Parent.AnalyticsContext)

return function(props)
	local mock = analytics.mock()

	local v = tostring(math.random(999999999))

	return Roact.createElement(
		AnalyticsContext.Provider,
		{
			value = RoactChatAnalytics.new(mock, v)
		},
		Roact.oneChild(props[Roact.Children])
	)
end
