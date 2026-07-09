local ParentParent = script.Parent.Parent
local React = require(ParentParent.dependencies).React
local DiscoverabilityModalAnalyticsContext = require(script.Parent.DiscoverabilityModalAnalyticsContext)

return function() -- line: 6
	-- upvalues: React (copy), DiscoverabilityModalAnalyticsContext (copy)
	return React.useContext(DiscoverabilityModalAnalyticsContext)
end
