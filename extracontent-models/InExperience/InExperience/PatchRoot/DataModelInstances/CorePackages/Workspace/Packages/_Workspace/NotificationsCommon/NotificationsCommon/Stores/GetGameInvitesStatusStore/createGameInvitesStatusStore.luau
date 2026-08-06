local Parent = script:FindFirstAncestor("NotificationsCommon").Parent

require(Parent.Signals)

local createSessionScopedSignal = require(Parent.SignalsUtils).createSessionScopedSignal

return function() -- line: 15
	-- upvalues: createSessionScopedSignal (copy)
	local v3, v4 = createSessionScopedSignal({})

	return {
		getGameInvitesStatus = v3,
		receivedUserInviteStatus = function(p1, s1: string) -- line: 18
			-- upvalues: v4 (copy)
			local str = tostring(p1)

			v4(function(t1: {[any]: any}) -- line: 20
				-- upvalues: str (copy), s1 (copy)
				local v9 = table.clone(t1)

				v9[str] = s1

				return v9
			end)
		end,
		reset = function() -- line: 27
			-- upvalues: v4 (copy)
			v4({})
		end
	}
end
