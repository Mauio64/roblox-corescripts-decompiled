local createGetBlockedUsers = require("@game/CorePackages/Workspace/Packages/_Index/UserBlockingNetworking/UserBlockingNetworking/networkRequests/createGetBlockedUsers")
local createBlockUserById = require("@game/CorePackages/Workspace/Packages/_Index/UserBlockingNetworking/UserBlockingNetworking/networkRequests/createBlockUserById")
local createUnblockUserById = require("@game/CorePackages/Workspace/Packages/_Index/UserBlockingNetworking/UserBlockingNetworking/networkRequests/createUnblockUserById")
local createIsBlockedById = require("@game/CorePackages/Workspace/Packages/_Index/UserBlockingNetworking/UserBlockingNetworking/networkRequests/createIsBlockedById")

return function(p2)
	return {
		GetBlockedUsers = createGetBlockedUsers(p2),
		BlockUserById = createBlockUserById(p2),
		UnblockUserById = createUnblockUserById(p2),
		IsBlockedById = createIsBlockedById(p2)
	}
end
