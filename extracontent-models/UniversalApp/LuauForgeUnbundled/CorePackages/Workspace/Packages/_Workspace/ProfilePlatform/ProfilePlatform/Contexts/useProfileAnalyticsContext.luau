local ProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileAnalyticsContext")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

return function()
	return React.useContext(ProfileAnalyticsContext)
end
