local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/Rodux")
require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/Models/ExperienceMediaModel")

return function(p2)
	return (Rodux.createReducer({}, {
		[p2.GetExperienceMedia.Succeeded.name] = function(p3, p4)
			local id = p4.ids[1]

			return Cryo.Dictionary.join(p3, { [id] = p4.responseBody.data })
		end,
		[p2.GetExperienceMedia.Failed.name] = function(p3, p4)
			return p3
		end
	}))
end
