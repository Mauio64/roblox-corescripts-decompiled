local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/UserBlockingRodux/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserBlockingRodux/Cryo")

return function(p2)
	local userBlockingNetworking = p2.userBlockingNetworking

	return Rodux.createReducer({}, {
		[userBlockingNetworking.BlockUserById.Succeeded.name] = function(p3, p4)
			local users = tostring(p4.namedIds.users)
			return Cryo.Dictionary.join(p3, { [users] = true })
		end,
		[userBlockingNetworking.UnblockUserById.Succeeded.name] = function(p3, p4)
			local users = tostring(p4.namedIds.users)
			return Cryo.Dictionary.join(p3, { [users] = false })
		end,
		[userBlockingNetworking.IsBlockedById.Succeeded.name] = function(p3, p4)
			local users = tostring(p4.namedIds.users)
			local responseBody = p4.responseBody or false
			return Cryo.Dictionary.join(p3, { [users] = responseBody })
		end
	})
end
