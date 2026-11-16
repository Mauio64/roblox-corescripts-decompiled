local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/UserBlockingNetworking/UserBlockingNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.POST("UnblockUserById", function(callback, p3)
		return callback(API_URL, { params = p3.currentUserId }):path("user-blocking-api"):path("v1"):path("users"):id(p3.userId):path("unblock-user"):body({})
	end)
end
