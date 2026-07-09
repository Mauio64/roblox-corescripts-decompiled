local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local llama = require(AddFriendsStateParent.llama)
local Rodux = require(AddFriendsStateParent.Rodux)
local FriendsNetworking = require(AddFriendsState.Networking.FriendsNetworking)

return Rodux.createReducer({}, {
	[FriendsNetworking.GetFollowingExists.Succeeded.name] = function(p1, p2) -- line: 12
		-- upvalues: llama (copy)
		local t1 = {}

		llama.List.every(p2.responseBody.followings, function(p3) -- line: 14
			-- upvalues: t1 (copy)
			t1[tostring(p3.userId)] = {
				isFollowing = p3.isFollowing,
				isFollowed = p3.isFollowed
			}

			return true
		end)

		return llama.Dictionary.join(p1, t1)
	end
})
