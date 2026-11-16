local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local react = dependencies.React
local DiscoverabilityModalAnalyticsContext = require(script.Parent.DiscoverabilityModalAnalyticsContext)

return function()
	return react.useContext(DiscoverabilityModalAnalyticsContext)
end
