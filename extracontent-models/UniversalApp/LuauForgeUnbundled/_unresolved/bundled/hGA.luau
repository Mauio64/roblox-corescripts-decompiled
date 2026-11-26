local module = require("@luauforge/bundled/hGq")

local llama = module.llama
local roduxFriends = module.RoduxFriends

local function friendshipCreatedWithUser(p2)
	return roduxFriends.Actions.FriendshipCreated(p2.id, "localUserId")
end

local v5 = {
	AddUser = function(p2)
		if p2.user.isFriend then
			return { friendshipCreatedWithUser(p2.user) }
		end

		return { p2 }
	end,
	AddUsers = function(p2)
		return llama.Dictionary.values(llama.Dictionary.map(p2.users, function(p3, p4)
			if p3.isFriend then
				return friendshipCreatedWithUser(p3)
			end

			return nil
		end))
	end,
	SetFriendRequestsCount = function(p2)
		return { roduxFriends.Actions.RequestReceivedCountUpdated(p2.count) }
	end
}

local v6 = roduxFriends.installReducer()

return function(p2, p3)
	local v7 = v5[p3.type]
	local v8 = not v7 and { p3 } or v7(p3)
	return llama.List.reduce(v8, v6, p2 or {
		countsByUserId = {},
		byUserId = {},
		requests = { receivedCount = 0 }
	})
end
