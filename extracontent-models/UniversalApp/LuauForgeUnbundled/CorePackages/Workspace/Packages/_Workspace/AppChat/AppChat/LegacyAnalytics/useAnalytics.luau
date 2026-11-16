local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local AnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/AnalyticsContext")

return function()
	return React.useContext(AnalyticsContext)
end
