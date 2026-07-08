local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local RoduxSquadsParent = RoduxSquads.Parent
local Rodux = require(RoduxSquadsParent.Rodux)
local CurrentExperienceInviteStatusUpdated = require(RoduxSquads.Actions).CurrentExperienceInviteStatusUpdated

require(script.Parent.Parent.RoduxSquadsTypes)

return function() -- line: 12
	-- upvalues: Rodux (copy), CurrentExperienceInviteStatusUpdated (copy)
	return Rodux.createReducer(false, {
		[CurrentExperienceInviteStatusUpdated.name] = function(_: boolean, p1) -- line: 14
			return p1.payload.isExperienceInvitePending
		end
	})
end
