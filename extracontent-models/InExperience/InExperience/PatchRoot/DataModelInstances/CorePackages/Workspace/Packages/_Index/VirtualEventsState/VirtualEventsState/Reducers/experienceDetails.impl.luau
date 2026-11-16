local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local Cryo = require(VirtualEventsState.Parent.Cryo)
local Rodux = require(VirtualEventsState.Parent.Rodux)
require(VirtualEventsState.Models.ExperienceDetailsModel)

return function(p)
	return (Rodux.createReducer({}, {
		[p.GetExperiencesDetails.Succeeded.name] = function(p2, p3)
			local id = p3.ids[1]
			local v = p3.responseBody.data[1]

			return Cryo.Dictionary.join(p2, { [id] = v })
		end,
		[p.GetExperiencesDetails.Failed.name] = function(p2, _)
			return p2
		end
	}))
end
