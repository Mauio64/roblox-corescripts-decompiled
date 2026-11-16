local EditProfileBackgroundAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Analytics/EditProfileBackgroundAnalyticsContext")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/React")

return function()
	return React.useContext(EditProfileBackgroundAnalyticsContext)
end
