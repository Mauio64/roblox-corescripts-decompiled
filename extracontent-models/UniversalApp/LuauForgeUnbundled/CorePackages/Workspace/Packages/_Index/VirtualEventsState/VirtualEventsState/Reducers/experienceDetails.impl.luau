local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/Rodux")
require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/Models/ExperienceDetailsModel")

return function(p2)
	return (Rodux.createReducer({}, {
		[p2.GetExperiencesDetails.Succeeded.name] = function(p3, p4)
			local id = p4.ids[1]
			local v6 = p4.responseBody.data[1]

			return Cryo.Dictionary.join(p3, { [id] = v6 })
		end,
		[p2.GetExperiencesDetails.Failed.name] = function(p3, p4)
			return p3
		end
	}))
end
