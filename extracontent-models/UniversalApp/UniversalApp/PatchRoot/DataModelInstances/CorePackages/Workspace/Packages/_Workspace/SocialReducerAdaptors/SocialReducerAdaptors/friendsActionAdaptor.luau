local SocialReducerAdaptors = script:FindFirstAncestor("SocialReducerAdaptors")
local dependencies = require(SocialReducerAdaptors.dependencies)
local Players = dependencies.Players
local llama = dependencies.llama

return function(p1, s1: string?) -- line: 13
	-- upvalues: Players (copy), llama (copy)
	local function friendshipCreatedWithUser(t1: {[any]: any}) -- line: 14
		-- upvalues: p1 (copy), s1 (copy), Players (copy)
		return p1.Actions.FriendshipCreated(t1.id, s1 or tostring(Players.LocalPlayer.UserId))
	end

	return {
		AddUser = function(t2: {[any]: any}) -- line: 19
			-- upvalues: friendshipCreatedWithUser (copy)
			if t2.user.isFriend then
				return { friendshipCreatedWithUser(t2.user) }
			end

			return { t2 }
		end,
		AddUsers = function(t3: {[any]: any}) -- line: 27
			-- upvalues: llama (copy), friendshipCreatedWithUser (copy)
			return llama.Dictionary.values(llama.Dictionary.map(t3.users, function(p2, _) -- line: 28
				-- upvalues: friendshipCreatedWithUser (copy)
				if p2.isFriend then
					return friendshipCreatedWithUser(p2)
				end

				return nil
			end))
		end,
		SetFriendRequestsCount = function(t4: {[any]: any}) -- line: 37
			-- upvalues: p1 (copy)
			return { p1.Actions.RequestReceivedCountUpdated(t4.count) }
		end
	}
end
