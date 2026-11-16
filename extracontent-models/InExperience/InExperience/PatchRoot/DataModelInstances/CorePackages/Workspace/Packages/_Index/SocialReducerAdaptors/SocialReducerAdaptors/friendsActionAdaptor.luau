local SocialReducerAdaptors = script:FindFirstAncestor("SocialReducerAdaptors")
local dependencies = require(SocialReducerAdaptors.dependencies)
local players = dependencies.Players
local llama = dependencies.llama

return function(p, p2: string?)
	local function friendshipCreatedWithUser(p3)
		return p.Actions.FriendshipCreated(p3.id, p2 or tostring(players.LocalPlayer.UserId))
	end

	return {
		AddUser = function(p3)
			if p3.user.isFriend then
				return { friendshipCreatedWithUser(p3.user) }
			end

			return { p3 }
		end,
		AddUsers = function(p3)
			return llama.Dictionary.values(llama.Dictionary.map(p3.users, function(p4, _)
				if p4.isFriend then
					return friendshipCreatedWithUser(p4)
				end

				return nil
			end))
		end,
		SetFriendRequestsCount = function(p3)
			return { p.Actions.RequestReceivedCountUpdated(p3.count) }
		end
	}
end
