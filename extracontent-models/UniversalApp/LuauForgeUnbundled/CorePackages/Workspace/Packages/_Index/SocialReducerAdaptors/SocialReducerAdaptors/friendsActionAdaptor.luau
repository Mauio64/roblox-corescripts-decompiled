local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/SocialReducerAdaptors/SocialReducerAdaptors/dependencies")
local players = dependencies.Players
local llama = dependencies.llama

return function(p2, p3)
	local function friendshipCreatedWithUser(p4)
		return p2.Actions.FriendshipCreated(p4.id, p3 or tostring(players.LocalPlayer.UserId))
	end

	return {
		AddUser = function(p4)
			if p4.user.isFriend then
				return { friendshipCreatedWithUser(p4.user) }
			end

			return { p4 }
		end,
		AddUsers = function(p4)
			return llama.Dictionary.values(llama.Dictionary.map(p4.users, function(p5, p6)
				if p5.isFriend then
					return friendshipCreatedWithUser(p5)
				end

				return nil
			end))
		end,
		SetFriendRequestsCount = function(p4)
			return { p2.Actions.RequestReceivedCountUpdated(p4.count) }
		end
	}
end
