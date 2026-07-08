local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local llama = require(ParentParentParent.llama)

require(ParentParent.roduxFriendsTypes)

local Actions = ParentParent.Actions
local FriendRequestCreated = require(Actions.FriendRequestCreated)
local t1 = {}

return function(p1) -- line: 16
	-- upvalues: Rodux (copy), t1 (copy), llama (copy), FriendRequestCreated (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(t2: {[any]: any}, p2) -- line: 20
			-- upvalues: llama (copy)
			local data = p2.responseBody.data
			local t3 = {}

			for _, v in pairs(data) do
				t3[tostring(v.id)] = v.friendRequest.contactName
			end

			return llama.Dictionary.join(t2, t3)
		end,
		[FriendRequestCreated.name] = function(t4: {[any]: any}, p3) -- line: 31
			-- upvalues: llama (copy)
			local str = tostring(p3.requesteeId)
			local contactName = p3.contactName

			return llama.Dictionary.join(t4, {
				[str] = contactName
			})
		end
	})
end
