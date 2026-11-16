local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)
local MockAnalyticsProvider = require(script.Parent.MockAnalyticsProvider)

return function(analyticsElement)
	return Roact.createElement(MockAnalyticsProvider, {}, { AnalyticsElement = analyticsElement })
end
