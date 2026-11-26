local react = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/dependencies").React
local DiscoverabilityModalAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/DiscoverabilityModalAnalyticsContext")

return function()
	return react.useContext(DiscoverabilityModalAnalyticsContext)
end
