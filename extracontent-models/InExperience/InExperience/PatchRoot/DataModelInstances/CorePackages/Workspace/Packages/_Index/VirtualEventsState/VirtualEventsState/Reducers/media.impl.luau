local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local Cryo = require(VirtualEventsState.Parent.Cryo)
local Rodux = require(VirtualEventsState.Parent.Rodux)
require(VirtualEventsState.Models.ExperienceMediaModel)

return function(p)
	return (Rodux.createReducer({}, {
		[p.GetExperienceMedia.Succeeded.name] = function(p2, p3)
			local id = p3.ids[1]

			return Cryo.Dictionary.join(p2, { [id] = p3.responseBody.data })
		end,
		[p.GetExperienceMedia.Failed.name] = function(p2, _)
			return p2
		end
	}))
end
