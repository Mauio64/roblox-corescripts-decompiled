local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.roduxFriendsTypes)

local Actions = ParentParent.Actions
local FriendRequestCreated = require(Actions.FriendRequestCreated)
local FriendRequestDeclined = require(Actions.FriendRequestDeclined)
local FriendshipCreated = require(Actions.FriendshipCreated)
local removeIdsFromRequestsStore = require(ParentParent.Reducers.Friends.utils.removeIdsFromRequestsStore)
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
				t5[tostring(v.id)] = DateTime.fromIsoDate(v.friendRequest.sentAt)
			end

			return llama.Dictionary.join(t4, t5)
		end,
		[FriendRequestCreated.name] = function(t6: {[any]: any}, p5) -- line: 45
			-- upvalues: llama (copy)
			local str = tostring(p5.requesteeId)
			local sentAt = p5.sentAt

			return llama.Dictionary.join(t6, {
				[str] = DateTime.fromIsoDate(sentAt)
			})
		end,
		[FriendRequestDeclined.name] = function(t7: {[any]: any}, p6) -- line: 53
			-- upvalues: removeIdsFromRequestsStore (copy)
			local ids = p6.ids

			return removeIdsFromRequestsStore(t7, ids)
		end,
		[FriendshipCreated.name] = function(t8: {[any]: any}, p7) -- line: 58
			-- upvalues: removeIdsFromRequestsStore (copy)
			return removeIdsFromRequestsStore(t8, {
				p7.payload.userId1,
				p7.payload.userId2
			})
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function() -- line: 61
			-- upvalues: t1 (copy)
			return t1
		end
	})
end
