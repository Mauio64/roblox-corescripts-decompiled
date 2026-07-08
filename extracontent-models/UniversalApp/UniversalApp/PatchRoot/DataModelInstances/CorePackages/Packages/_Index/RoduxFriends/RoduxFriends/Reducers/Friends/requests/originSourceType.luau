local Parent = script:FindFirstAncestor("RoduxFriends").Parent
local Rodux = require(Parent.Rodux)
local ParentParent = script.Parent.Parent.Parent.Parent
local getDeepValue = require(ParentParent.getDeepValue)
local llama = require(Parent.llama)
local t1 = {}

return function(p1) -- line: 12
	-- upvalues: Rodux (copy), t1 (copy), llama (copy), getDeepValue (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(_, p3) -- line: 16
			-- upvalues: llama (copy), getDeepValue (copy)
			local data = p3.responseBody.data

			return (llama.Dictionary.map(data, function(p4) -- line: 18
				-- upvalues: getDeepValue (copy)
				return getDeepValue(p4, "friendRequest.originSourceType"), (tostring(p4.id))
			end))
		end
	})
end
