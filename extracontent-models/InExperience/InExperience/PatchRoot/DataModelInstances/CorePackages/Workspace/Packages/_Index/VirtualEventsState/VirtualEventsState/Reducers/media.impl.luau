local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")
local Cryo = require(VirtualEventsState.Parent.Cryo)
local Rodux = require(VirtualEventsState.Parent.Rodux)

require(VirtualEventsState.Models.ExperienceMediaModel)

return function(p1) -- line: 11
	-- upvalues: Rodux (copy), Cryo (copy)
	return (Rodux.createReducer({}, {
		[p1.GetExperienceMedia.Succeeded.name] = function(t1: {[any]: any}, p2) -- line: 13
			-- upvalues: Cryo (copy)
			local v7 = p2.ids[1]

			return Cryo.Dictionary.join(t1, {
				[v7] = p2.responseBody.data
			})
		end,
		[p1.GetExperienceMedia.Failed.name] = function(t2: {[any]: any}, _) -- line: 21
			return t2
		end
	}))
end
