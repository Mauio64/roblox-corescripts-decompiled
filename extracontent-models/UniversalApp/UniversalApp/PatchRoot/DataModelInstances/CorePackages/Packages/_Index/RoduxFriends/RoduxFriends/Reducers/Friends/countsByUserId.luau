local RoduxFriends = script:FindFirstAncestor("RoduxFriends")
local RoduxFriendsParent = RoduxFriends.Parent
local llama = require(RoduxFriendsParent.llama)
local Actions = RoduxFriends.Actions
local FriendshipCreated = require(Actions.FriendshipCreated)
local FriendshipDestroyed = require(Actions.FriendshipDestroyed)
local addUser = require(script.Parent.utils.addUser)
local removeUser = require(script.Parent.utils.removeUser)
local setFriendshipsInStore = require(script.Parent.utils.setFriendshipsInStore)
local removeTargetUserFriendshipInStore = require(script.Parent.utils.removeTargetUserFriendshipInStore)
local countUserFriendsInStore = require(script.Parent.utils.countUserFriendsInStore)
local t1 = {
	byUserId = {},
	countsByUserId = {}
}

return function(p1) -- line: 20
	-- upvalues: t1 (copy), FriendshipCreated (copy), llama (copy), addUser (copy), FriendshipDestroyed (copy), removeUser (copy), setFriendshipsInStore (copy), countUserFriendsInStore (copy), removeTargetUserFriendshipInStore (copy)
	local friendsNetworking = p1.friendsNetworking

	return function(p2, p3) -- line: 23
		-- upvalues: t1 (copy), FriendshipCreated (copy), llama (copy), addUser (copy), FriendshipDestroyed (copy), removeUser (copy), friendsNetworking (copy), setFriendshipsInStore (copy), countUserFriendsInStore (copy), removeTargetUserFriendshipInStore (copy)
		local v17 = p2 or t1

		if p3 and p3.type == FriendshipCreated.name then
			assert(type(p3.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p3.payload.userId2) == "string", "Expected userId2 to be a string")

			return llama.Dictionary.join(v17.countsByUserId, {
				[p3.payload.userId1] = #addUser(v17.byUserId[p3.payload.userId1], p3.payload.userId2),
				[p3.payload.userId2] = #addUser(v17.byUserId[p3.payload.userId2], p3.payload.userId1)
			})
		end

		if p3 and p3.type == FriendshipDestroyed.name then
			assert(type(p3.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p3.payload.userId2) == "string", "Expected userId2 to be a string")

			return llama.Dictionary.join(v17.countsByUserId, {
				[p3.payload.userId1] = #removeUser(v17.byUserId[p3.payload.userId1], p3.payload.userId2),
				[p3.payload.userId2] = #removeUser(v17.byUserId[p3.payload.userId2], p3.payload.userId1)
			})
		end

		if p3 and p3.type == friendsNetworking.GetFriendsFromUserId.Succeeded.name then
			local v18 = setFriendshipsInStore(v17.byUserId, p3)

			return countUserFriendsInStore(v18)
		end

		if p3 and p3.type == friendsNetworking.UnfriendTargetUserId.Succeeded.name then
			local v19 = removeTargetUserFriendshipInStore(p2.byUserId, p3)

			return countUserFriendsInStore(v19)
		end

		return v17.countsByUserId
	end
end
