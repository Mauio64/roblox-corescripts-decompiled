local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local MockAnalyticsProvider = require(script.Parent.MockAnalyticsProvider)

return function(p1) -- line: 7
	-- upvalues: Roact (copy), MockAnalyticsProvider (copy)
	return Roact.createElement(MockAnalyticsProvider, {}, {
		AnalyticsElement = p1
	})
end
