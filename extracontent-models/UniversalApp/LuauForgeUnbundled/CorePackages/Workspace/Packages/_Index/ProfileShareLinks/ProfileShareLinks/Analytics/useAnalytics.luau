local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/React")

local initializeProfileShareLinksAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Analytics/initializeProfileShareLinksAnalytics")

return function()
	return React.useMemo(function()
		return initializeProfileShareLinksAnalytics()
	end, {})
end
