local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local ExperienceService = require(scriptParentParent.ExperienceService)
local ToastNotificationWrapper = require(scriptParent.ToastNotificationWrapper)
local ExperienceService2 = ExperienceService.ExperienceService

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), ExperienceService2 (copy), ToastNotificationWrapper (copy)
	local v8, v9 = React.useState(false)

	React.useEffect(function() -- line: 16
		-- upvalues: ExperienceService2 (copy), v9 (copy)
		ExperienceService2:RegisterForExperienceJoin(function() -- line: 17
			-- upvalues: v9 (copy)
			v9(true)
		end)
		ExperienceService2:RegisterForExperienceLeave(function() -- line: 20
			-- upvalues: v9 (copy)
			v9(false)
		end)
	end, {})

	return not v8 and React.createElement(ToastNotificationWrapper, {
		renderLocation = "universalApp",
		displayOrder = t1.displayOrder
	})
end
