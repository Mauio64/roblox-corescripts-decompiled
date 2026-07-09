local SocialTabState = script:FindFirstAncestor("SocialTabState")
local dependencies = require(SocialTabState.dependencies)
local llama = dependencies.llama
local RoduxFriends = dependencies.RoduxFriends

local function friendshipCreatedWithUser(p1) -- line: 8
	-- upvalues: RoduxFriends (copy)
	return RoduxFriends.Actions.FriendshipCreated(p1.id, "localUserId")
end

local t1 = {
	AddUser = function(p2) -- line: 13
		-- upvalues: friendshipCreatedWithUser (copy)
		if p2.user.isFriend then
			return { friendshipCreatedWithUser(p2.user) }
		end

		return { p2 }
	end,
	AddUsers = function(p3) -- line: 21
		-- upvalues: llama (copy), friendshipCreatedWithUser (copy)
		return llama.Dictionary.values(llama.Dictionary.map(p3.users, function(p4, _) -- line: 22
			-- upvalues: friendshipCreatedWithUser (copy)
			if p4.isFriend then
				return friendshipCreatedWithUser(p4)
			end

			return nil
		end))
	end,
	SetFriendRequestsCount = function(p6) -- line: 31
		-- upvalues: RoduxFriends (copy)
		return { RoduxFriends.Actions.RequestReceivedCountUpdated(p6.count) }
	end
}
local v7 = RoduxFriends.installReducer()

return function(p7, p8) -- line: 38
	-- upvalues: t1 (copy), llama (copy), v7 (copy)
	local v14 = p7 or {
		countsByUserId = {},
		byUserId = {},
		requests = {
			receivedCount = 0
		}
	}
	local t2 = { p8 }
	local v16 = t1[p8.type]

	if v16 then
		t2 = v16(p8)
	end

	return llama.List.reduce(t2, v7, v14)
end
