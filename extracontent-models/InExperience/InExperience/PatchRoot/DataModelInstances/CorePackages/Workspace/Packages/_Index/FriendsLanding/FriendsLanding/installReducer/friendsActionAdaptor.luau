local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local players = dependencies.Players

local llama = dependencies.llama
local roduxFriends = dependencies.RoduxFriends

return function(p: string?)
	local function friendshipCreatedWithUser(p2)
		return roduxFriends.Actions.FriendshipCreated(p2.id, p or tostring(players.LocalPlayer.UserId))
	end

	return {
		AddUser = function(p2)
			if p2.user.isFriend then
				return { friendshipCreatedWithUser(p2.user) }
			end

			return { p2 }
		end,
		AddUsers = function(p2)
			return llama.Dictionary.values(llama.Dictionary.map(p2.users, function(p3, _)
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
end
