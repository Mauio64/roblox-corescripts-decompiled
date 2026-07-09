local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Players = dependencies.Players
local llama = dependencies.llama
local RoduxFriends = dependencies.RoduxFriends

return function(s1: string?) -- line: 9
	-- upvalues: RoduxFriends (copy), Players (copy), llama (copy)
	local function friendshipCreatedWithUser(p1) -- line: 10
		-- upvalues: RoduxFriends (copy), s1 (copy), Players (copy)
		return RoduxFriends.Actions.FriendshipCreated(p1.id, s1 or tostring(Players.LocalPlayer.UserId))
	end

	return {
		AddUser = function(p2) -- line: 15
			-- upvalues: friendshipCreatedWithUser (copy)
			if p2.user.isFriend then
				return { friendshipCreatedWithUser(p2.user) }
			end

			return { p2 }
		end,
		AddUsers = function(p3) -- line: 23
			-- upvalues: llama (copy), friendshipCreatedWithUser (copy)
			return llama.Dictionary.values(llama.Dictionary.map(p3.users, function(p4, _) -- line: 24
				-- upvalues: friendshipCreatedWithUser (copy)
				if p4.isFriend then
					return friendshipCreatedWithUser(p4)
				end

				return nil
			end))
		end,
		SetFriendRequestsCount = function(p6) -- line: 33
			-- upvalues: RoduxFriends (copy)
			return { RoduxFriends.Actions.RequestReceivedCountUpdated(p6.count) }
		end
	}
end
