local parent = script:FindFirstAncestor("RoduxSquads").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(
	script.Name,
	function(experienceInviteId: string, membershipEntityId: string, notificationId: string, isInviter: boolean)
		return {
			payload = {
				experienceInviteId = experienceInviteId,
				membershipEntityId = membershipEntityId,
				notificationId = notificationId,
				isInviter = isInviter
			}
		}
	end
)
