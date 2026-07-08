local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local Actions = ParentParent.Actions
local FriendRequestCreated = require(Actions.FriendRequestCreated)
local FriendRequestDeclined = require(Actions.FriendRequestDeclined)

require(ParentParent.roduxFriendsTypes)

local removeIdsFromRequestsStore = require(ParentParent.Reducers.Friends.utils.removeIdsFromRequestsStore)
local llama = require(ParentParentParent.llama)
local t1 = {}

return function(p1) -- line: 18
	-- upvalues: Rodux (copy), t1 (copy), removeIdsFromRequestsStore (copy), llama (copy), FriendRequestCreated (copy), FriendRequestDeclined (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(t2: {[any]: any}, p2) -- line: 22
			-- upvalues: removeIdsFromRequestsStore (copy)
			local ids = p2.ids

			return removeIdsFromRequestsStore(t2, ids)
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(t3: {[any]: any}, p3) -- line: 27
			-- upvalues: removeIdsFromRequestsStore (copy)
			local ids = p3.ids

			return removeIdsFromRequestsStore(t3, ids)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(t4: {[any]: any}, p4) -- line: 35
			-- upvalues: llama (copy)
			local data = p4.responseBody.data
			local t5 = {}

			for _, v in pairs(data) do
				t5[tostring(v.id)] = v.friendRequest.senderNickname
			end

			return (llama.Dictionary.join(t4, t5))
		end,
		[FriendRequestCreated.name] = function(t6: {[any]: any}, p5) -- line: 50
			-- upvalues: llama (copy)
			local requesteeId = p5.requesteeId
			local senderNickname = p5.senderNickname

			return llama.Dictionary.join(t6, {
				[tostring(requesteeId)] = senderNickname
			})
		end,
		[FriendRequestDeclined.name] = function(t7: {[any]: any}, p6) -- line: 58
			-- upvalues: removeIdsFromRequestsStore (copy)
			local ids = p6.ids

			return removeIdsFromRequestsStore(t7, ids)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function() -- line: 63
			return {}
		end
	})
end
