local SetAliasAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/SetAliasAnalyticsContext")
local react = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/dependencies").React

return function()
	return react.useContext(SetAliasAnalyticsContext)
end
