local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local PlayerContextualMenuAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Analytics/PlayerContextualMenuAnalyticsContext")

return function()
	return React.useContext(PlayerContextualMenuAnalyticsContext)
end
