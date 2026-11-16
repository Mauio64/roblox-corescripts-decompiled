local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local AnalyticsConsumer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/AnalyticsConsumer")

return function(callback)
	assert(type(callback) == "function", "Expect renderCallback to be a function.")
	return Roact.createElement(AnalyticsConsumer, { render = callback })
end
