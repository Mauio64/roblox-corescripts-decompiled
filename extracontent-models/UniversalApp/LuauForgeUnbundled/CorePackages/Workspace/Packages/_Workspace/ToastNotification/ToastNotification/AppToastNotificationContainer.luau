local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local ExperienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ExperienceService")
local ToastNotificationWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/ToastNotificationWrapper")

local experienceService = ExperienceService.ExperienceService

return function(p2)
	local state, setState = React.useState(false)
	React.useEffect(function()
		experienceService:RegisterForExperienceJoin(function()
			setState(true)
		end)
		experienceService:RegisterForExperienceLeave(function()
			setState(false)
		end)
	end, {})

	return not state
		and React.createElement(ToastNotificationWrapper, {
			displayOrder = p2.displayOrder,
			renderLocation = "universalApp"
		})
end
