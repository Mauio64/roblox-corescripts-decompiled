local parent = script.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local ExperienceService = require(parent2.ExperienceService)
local ToastNotificationWrapper = require(parent.ToastNotificationWrapper)

local experienceService = ExperienceService.ExperienceService

return function(p)
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
			displayOrder = p.displayOrder,
			renderLocation = "universalApp"
		})
end
