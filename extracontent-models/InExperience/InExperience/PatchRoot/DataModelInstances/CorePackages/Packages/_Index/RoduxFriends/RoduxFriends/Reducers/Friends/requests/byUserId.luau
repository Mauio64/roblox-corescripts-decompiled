local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local Actions = ParentParent.Actions
local FriendRequestCreated = require(Actions.FriendRequestCreated)
local FriendRequestDeclined = require(Actions.FriendRequestDeclined)
local FriendshipCreated = require(Actions.FriendshipCreated)
local removeIdsFromRequestsStore = require(ParentParent.Reducers.Friends.utils.removeIdsFromRequestsStore)

require(ParentParent.roduxFriendsTypes)

local llama = require(ParentParentParent.llama)
local t1 = {}

return function(p1) -- line: 20
	-- upvalues: Rodux (copy), t1 (copy), removeIdsFromRequestsStore (copy), llama (copy), FriendRequestCreated (copy), FriendRequestDeclined (copy), FriendshipCreated (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(t2: {[any]: any}, p2) -- line: 24
			-- upvalues: removeIdsFromRequestsStore (copy)
			local ids = p2.ids

			return removeIdsFromRequestsStore(t2, ids)
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(t3: {[any]: any}, p3) -- line: 29
			-- upvalues: removeIdsFromRequestsStore (copy)
			local ids = p3.ids

			return removeIdsFromRequestsStore(t3, ids)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(t4: {[any]: any}, p4) -- line: 34
			-- upvalues: llama (copy)
			local data = p4.responseBody.data
			local t5 = {}

			for _, v in pairs(data) do
				t5[tostring(v.id)] = true
			end

			return (llama.Dictionary.join(t4, t5))
		end,
		[FriendRequestCreated.name] = function(t6: {[any]: any}, p5) -- line: 46
			-- upvalues: llama (copy)
			local requesteeId = p5.requesteeId

			return llama.Dictionary.join(t6, {
				[tostring(requesteeId)] = true
			})
		end,
		[FriendRequestDeclined.name] = function(t7: {[any]: any}, p6) -- line: 53
			-- upvalues: removeIdsFromRequestsStore (copy)
			local ids = p6.ids

			return removeIdsFromRequestsStore(t7, ids)
		end,
		[FriendshipCreated.name] = function(p7, p8) -- line: 58
			-- upvalues: removeIdsFromRequestsStore (copy)
			assert(type(p8.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p8.payload.userId2) == "string", "Expected userId2 to be a string")

			return removeIdsFromRequestsStore(p7, {
				p8.payload.userId1,
				p8.payload.userId2
			})
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function() -- line: 64
			return {}
		end
	})
end
