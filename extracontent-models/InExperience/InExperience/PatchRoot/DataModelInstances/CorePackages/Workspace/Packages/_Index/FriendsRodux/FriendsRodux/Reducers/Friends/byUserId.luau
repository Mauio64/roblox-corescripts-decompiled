local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local FriendsRoduxParent = FriendsRodux.Parent
local Rodux = require(FriendsRoduxParent.Rodux)
local llama = require(FriendsRoduxParent.llama)
local Actions = FriendsRodux.Actions
local FriendshipCreated = require(Actions.FriendshipCreated)
local FriendshipDestroyed = require(Actions.FriendshipDestroyed)

require(FriendsRodux.roduxFriendsTypes)

local addUser = require(script.Parent.utils.addUser)
local removeUser = require(script.Parent.utils.removeUser)
local setFriendshipsInStore = require(script.Parent.utils.setFriendshipsInStore)
local removeTargetUserFriendshipInStore = require(script.Parent.utils.removeTargetUserFriendshipInStore)
local t1 = {}

return function(p1) -- line: 19
	-- upvalues: Rodux (copy), t1 (copy), FriendshipCreated (copy), llama (copy), addUser (copy), FriendshipDestroyed (copy), removeUser (copy), setFriendshipsInStore (copy), removeTargetUserFriendshipInStore (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[FriendshipCreated.name] = function(p2, p3) -- line: 23
			-- upvalues: llama (copy), addUser (copy)
			assert(type(p3.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p3.payload.userId2) == "string", "Expected userId2 to be a string")

			return llama.Dictionary.join(p2, {
				[p3.payload.userId1] = addUser(p2[p3.payload.userId1], p3.payload.userId2),
				[p3.payload.userId2] = addUser(p2[p3.payload.userId2], p3.payload.userId1)
			})
		end,
		[FriendshipDestroyed.name] = function(p4, p5) -- line: 33
			-- upvalues: llama (copy), removeUser (copy)
			assert(type(p5.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p5.payload.userId2) == "string", "Expected userId2 to be a string")

			return llama.Dictionary.join(p4, {
				[p5.payload.userId1] = removeUser(p4[p5.payload.userId1], p5.payload.userId2),
				[p5.payload.userId2] = removeUser(p4[p5.payload.userId2], p5.payload.userId1)
			})
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p6, p7) -- line: 43
			-- upvalues: setFriendshipsInStore (copy)
			return setFriendshipsInStore(p6, p7)
		end,
		[friendsNetworking.UnfriendTargetUserId.Succeeded.name] = function(p8, p9) -- line: 50
			-- upvalues: removeTargetUserFriendshipInStore (copy)
			return removeTargetUserFriendshipInStore(p8, p9)
		end,
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p10, p11) -- line: 56
			-- upvalues: llama (copy), addUser (copy)
			local str = tostring(p11.ids[1])
			local str2 = tostring(p11.additionalData.currentUserId)

			return llama.Dictionary.join(p10, {
				[str] = addUser(p10[str], str2),
				[str2] = addUser(p10[str2], str)
			})
		end
	})
end
