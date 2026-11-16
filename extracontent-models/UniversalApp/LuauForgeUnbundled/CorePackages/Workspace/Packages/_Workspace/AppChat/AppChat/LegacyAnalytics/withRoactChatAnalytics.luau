local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")

local RoactChatAnalyticsConsumer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/RoactChatAnalyticsConsumer")

return function(callback)
	assert(type(callback) == "function", "Expect renderCallback to be a function.")
	return Roact.createElement(RoactChatAnalyticsConsumer, { render = callback })
end
