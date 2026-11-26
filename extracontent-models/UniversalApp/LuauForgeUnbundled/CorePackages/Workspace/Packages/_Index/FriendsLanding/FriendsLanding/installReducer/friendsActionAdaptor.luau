local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local players = dependencies.Players

local llama = dependencies.llama
local roduxFriends = dependencies.RoduxFriends

return function(p2)
	local function friendshipCreatedWithUser(p3)
		return roduxFriends.Actions.FriendshipCreated(p3.id, p2 or tostring(players.LocalPlayer.UserId))
	end

	return {
		AddUser = function(p3)
			if p3.user.isFriend then
				return { friendshipCreatedWithUser(p3.user) }
			end

			return { p3 }
		end,
		AddUsers = function(p3)
			return llama.Dictionary.values(llama.Dictionary.map(p3.users, function(p4, p5)
				if p4.isFriend then
					return friendshipCreatedWithUser(p4)
				end

				return nil
			end))
		end,
		SetFriendRequestsCount = function(p3)
			return { roduxFriends.Actions.RequestReceivedCountUpdated(p3.count) }
		end
	}
end
