local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local Analytics = require(Parent.Analytics).Analytics
local RoactChatAnalytics = require(script.Parent.Parent.RoactChatAnalytics)
local AnalyticsContext = require(script.Parent.Parent.AnalyticsContext)

return function(p1) -- line: 9
	-- upvalues: Analytics (copy), Roact (copy), AnalyticsContext (copy), RoactChatAnalytics (copy)
	local v7 = Analytics.mock()
	local str = tostring(math.random(999999999))

	return Roact.createElement(AnalyticsContext.Provider, {
		value = RoactChatAnalytics.new(v7, str)
	}, Roact.oneChild(p1[Roact.Children]))
end
