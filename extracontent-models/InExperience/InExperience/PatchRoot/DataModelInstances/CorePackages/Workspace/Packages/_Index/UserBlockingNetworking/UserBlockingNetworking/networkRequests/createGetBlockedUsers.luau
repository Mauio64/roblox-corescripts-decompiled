local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.GET("GetBlockedUsers", function(callback, data)
		local currentUserId

		if data then
			currentUserId = data.currentUserId or nil
		end

		local path = callback(API_URL, { currentUserId = currentUserId }):path("user-blocking-api"):path("v1"):path("users"):path("get-blocked-users")
		local cursor

		if data then
			cursor = data.cursor or nil
		end

		return path:queryArgs({
			cursor = cursor,
			count = data and data.count or nil
		})
	end)
end
