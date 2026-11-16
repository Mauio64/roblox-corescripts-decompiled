require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/SignalsUtils").createSessionScopedSignal

return function()
	local sessionScopedSignal, v5 = createSessionScopedSignal({})

	return {
		getGameInvitesStatus = sessionScopedSignal,
		receivedUserInviteStatus = function(p2, p3)
			local v6 = tostring(p2)
			v5(function(p4)
				local clone = table.clone(p4)
				clone[v6] = p3
				return clone
			end)
		end,
		reset = function()
			v5({})
		end
	}
end
