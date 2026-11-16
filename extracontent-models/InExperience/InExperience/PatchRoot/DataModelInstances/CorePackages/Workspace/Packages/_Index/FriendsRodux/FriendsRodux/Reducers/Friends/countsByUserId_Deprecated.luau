local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local parent = FriendsRodux.Parent
local llama = require(parent.llama)

local Actions = FriendsRodux.Actions
local FriendshipCreated = require(Actions.FriendshipCreated)
local FriendshipDestroyed = require(Actions.FriendshipDestroyed)
local addUser = require(script.Parent.utils.addUser)
local removeUser = require(script.Parent.utils.removeUser)
local setFriendshipsInStore = require(script.Parent.utils.setFriendshipsInStore)
local removeTargetUserFriendshipInStore = require(script.Parent.utils.removeTargetUserFriendshipInStore)
local countUserFriendsInStore = require(script.Parent.utils.countUserFriendsInStore)
require(FriendsRodux.roduxFriendsTypes)

local v = { byUserId = {}, countsByUserId = {} }

return function(p)
	local friendsNetworking = p.friendsNetworking

	return function(p2, p3)
		local v2 = p2 or v

		if p3 and p3.type == FriendshipCreated.name then
			assert(type(p3.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p3.payload.userId2) == "string", "Expected userId2 to be a string")

			return (llama.Dictionary.join(v2.countsByUserId, {
				[p3.payload.userId1] = #addUser(v2.byUserId[p3.payload.userId1], p3.payload.userId2),
				[p3.payload.userId2] = #addUser(v2.byUserId[p3.payload.userId2], p3.payload.userId1)
			}))
		elseif p3 and p3.type == FriendshipDestroyed.name then
			assert(type(p3.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p3.payload.userId2) == "string", "Expected userId2 to be a string")

			return (llama.Dictionary.join(v2.countsByUserId, {
				[p3.payload.userId1] = #removeUser(v2.byUserId[p3.payload.userId1], p3.payload.userId2),
				[p3.payload.userId2] = #removeUser(v2.byUserId[p3.payload.userId2], p3.payload.userId1)
			}))
		else
			if p3 and p3.type == friendsNetworking.GetFriendsFromUserId.Succeeded.name then
				return (countUserFriendsInStore((setFriendshipsInStore(v2.byUserId, p3))))
			end

			if p3 and p3.type == friendsNetworking.UnfriendTargetUserId.Succeeded.name then
				return (countUserFriendsInStore((removeTargetUserFriendshipInStore(p2.byUserId, p3))))
			end

			return v2.countsByUserId
		end
	end
end
