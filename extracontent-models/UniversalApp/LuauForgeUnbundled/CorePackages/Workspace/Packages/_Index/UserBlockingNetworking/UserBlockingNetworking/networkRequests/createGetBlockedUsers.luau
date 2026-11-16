local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/UserBlockingNetworking/UserBlockingNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.GET("GetBlockedUsers", function(callback, data)
		local v7 = if data then data.currentUserId or nil else nil
		local path = callback(API_URL, { currentUserId = v7 }):path("user-blocking-api"):path("v1"):path("users"):path("get-blocked-users")

		local v9 = if data then data.cursor or nil else nil
		return path:queryArgs({
			cursor = v9,
			count = data and data.count or nil
		})
	end)
end
