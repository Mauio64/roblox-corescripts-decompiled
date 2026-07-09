local Parent = script:FindFirstAncestor("UserBlockingRodux").Parent
local Rodux = require(Parent.Rodux)
local Cryo = require(Parent.Cryo)

return function(p1) -- line: 9
	-- upvalues: Rodux (copy), Cryo (copy)
	local userBlockingNetworking = p1.userBlockingNetworking

	return Rodux.createReducer({}, {
		[userBlockingNetworking.BlockUserById.Succeeded.name] = function(p2, p3) -- line: 13
			-- upvalues: Cryo (copy)
			local str = tostring(p3.namedIds.users)

			return Cryo.Dictionary.join(p2, {
				[str] = true
			})
		end,
		[userBlockingNetworking.UnblockUserById.Succeeded.name] = function(p4, p5) -- line: 19
			-- upvalues: Cryo (copy)
			local str = tostring(p5.namedIds.users)

			return Cryo.Dictionary.join(p4, {
				[str] = false
			})
		end,
		[userBlockingNetworking.IsBlockedById.Succeeded.name] = function(p6, p7) -- line: 25
			-- upvalues: Cryo (copy)
			local str = tostring(p7.namedIds.users)
			local v15 = p7.responseBody or false

			return Cryo.Dictionary.join(p6, {
				[str] = v15
			})
		end
	})
end
