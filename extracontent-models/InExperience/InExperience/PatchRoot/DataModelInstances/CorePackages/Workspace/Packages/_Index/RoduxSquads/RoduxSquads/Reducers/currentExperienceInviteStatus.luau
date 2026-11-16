local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local parent = RoduxSquads.Parent
local Rodux = require(parent.Rodux)
local Actions = require(RoduxSquads.Actions)
local CurrentExperienceInviteStatusUpdated = Actions.CurrentExperienceInviteStatusUpdated

require(script.Parent.Parent.RoduxSquadsTypes)

return function()
	return Rodux.createReducer(false, {
		[CurrentExperienceInviteStatusUpdated.name] = function(_: boolean, p)
			return p.payload.isExperienceInvitePending
		end
	})
end
