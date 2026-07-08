local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local llama = require(ParentParentParent.llama)

require(ParentParent.roduxFriendsTypes)

local t1 = {}

return function(p1) -- line: 12
	-- upvalues: Rodux (copy), t1 (copy), llama (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p2, p3) -- line: 16
			-- upvalues: llama (copy)
			if not p3.queryArgs or not p3.queryArgs.userSort then
				return p2
			end

			local str = tostring(p3.namedIds.users)
			local v11 = p3.responseBody.data or {}
			local v12 = llama.Dictionary.map(v11, function(p4, p5) -- line: 24
				return p5, (tostring(p4.id))
			end)

			return llama.Dictionary.join(p2, {
				[str] = v12
			})
		end
	})
end
