local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux")
local currentExperienceInviteStatusUpdated = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Actions").CurrentExperienceInviteStatusUpdated

require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/RoduxSquadsTypes")

return function()
	return Rodux.createReducer(false, {
		[currentExperienceInviteStatusUpdated.name] = function(p2, p3)
			return p3.payload.isExperienceInvitePending
		end
	})
end
