local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local Actions = ParentParent.Actions
local FriendRequestCreated = require(Actions.FriendRequestCreated)
local FriendRequestDeclined = require(Actions.FriendRequestDeclined)
local removeIdsFromRequestsStore = require(ParentParent.Reducers.Friends.utils.removeIdsFromRequestsStore)

require(ParentParent.roduxFriendsTypes)

local llama = require(ParentParentParent.llama)
local t1 = {}

return function(p1) -- line: 19
	-- upvalues: Rodux (copy), t1 (copy), removeIdsFromRequestsStore (copy), llama (copy), FriendRequestCreated (copy), FriendRequestDeclined (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(t2: {[any]: any}, p2) -- line: 23
			-- upvalues: removeIdsFromRequestsStore (copy)
			local ids = p2.ids

			return removeIdsFromRequestsStore(t2, ids)
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(t3: {[any]: any}, p3) -- line: 28
			-- upvalues: removeIdsFromRequestsStore (copy)
			local ids = p3.ids

			return removeIdsFromRequestsStore(t3, ids)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(t4: {[any]: any}, p4) -- line: 33
			-- upvalues: llama (copy)
			local data = p4.responseBody.data
			local t5 = {}

			for _, v in pairs(data) do
				if v.mutualFriendsList then
					t5[tostring(v.id)] = llama.List.map(v.mutualFriendsList, function(p5) -- line: 40
						return (tostring(p5))
					end)
				end
			end

			return (llama.Dictionary.join(t4, t5))
		end,
		[FriendRequestCreated.name] = function(t6: {[any]: any}, p6) -- line: 49
			-- upvalues: llama (copy)
			local requesteeId = p6.requesteeId
			local mutualFriends = p6.mutualFriends

			return llama.Dictionary.join(t6, {
				[tostring(requesteeId)] = llama.List.map(mutualFriends, function(p7) -- line: 54
					return (tostring(p7))
				end)
			})
		end,
		[FriendRequestDeclined.name] = function(t7: {[any]: any}, p8) -- line: 59
			-- upvalues: removeIdsFromRequestsStore (copy)
			local ids = p8.ids

			return removeIdsFromRequestsStore(t7, ids)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function() -- line: 64
			return {}
		end
	})
end
