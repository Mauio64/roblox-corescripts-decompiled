local parent = script:FindFirstAncestor("NotificationsCommon").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

return function()
	local sessionScopedSignal, v = createSessionScopedSignal({})

	return {
		getGameInvitesStatus = sessionScopedSignal,
		receivedUserInviteStatus = function(p, p2: string)
			local v2 = tostring(p)
			v(function(p3)
				local clone = table.clone(p3)
				clone[v2] = p2
				return clone
			end)
		end,
		reset = function()
			v({})
		end
	}
end
