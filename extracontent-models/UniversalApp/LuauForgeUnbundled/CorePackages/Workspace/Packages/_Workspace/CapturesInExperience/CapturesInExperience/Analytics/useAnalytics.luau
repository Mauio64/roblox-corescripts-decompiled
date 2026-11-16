local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")

local CapturesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Context/CapturesContext")

return function()
	return { fireEvent = React.useContext(CapturesContext).fireAnalyticsEvent }
end
