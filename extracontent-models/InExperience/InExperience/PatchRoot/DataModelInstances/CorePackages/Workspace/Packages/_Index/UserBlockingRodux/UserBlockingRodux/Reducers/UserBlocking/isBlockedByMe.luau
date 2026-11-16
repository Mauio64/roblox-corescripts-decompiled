local parent = script:FindFirstAncestor("UserBlockingRodux").Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)

return function(p)
	local userBlockingNetworking = p.userBlockingNetworking

	return Rodux.createReducer({}, {
		[userBlockingNetworking.BlockUserById.Succeeded.name] = function(p2, p3)
			local users = tostring(p3.namedIds.users)
			return Cryo.Dictionary.join(p2, { [users] = true })
		end,
		[userBlockingNetworking.UnblockUserById.Succeeded.name] = function(p2, p3)
			local users = tostring(p3.namedIds.users)
			return Cryo.Dictionary.join(p2, { [users] = false })
		end,
		[userBlockingNetworking.IsBlockedById.Succeeded.name] = function(p2, p3)
			local users = tostring(p3.namedIds.users)
			local responseBody = p3.responseBody or false
			return Cryo.Dictionary.join(p2, { [users] = responseBody })
		end
	})
end
