local EditProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/EditProfileAnalyticsContext")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")

return function()
	return React.useContext(EditProfileAnalyticsContext)
end
