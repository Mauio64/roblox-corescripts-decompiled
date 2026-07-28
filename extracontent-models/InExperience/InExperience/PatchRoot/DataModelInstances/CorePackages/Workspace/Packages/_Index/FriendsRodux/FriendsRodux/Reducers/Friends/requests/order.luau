local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local FriendsRoduxParent = FriendsRodux.Parent
local Rodux = require(FriendsRoduxParent.Rodux)

require(FriendsRodux.roduxFriendsTypes)

local t1 = {}

return function(p1) -- line: 11
	-- upvalues: Rodux (copy), t1 (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p2, p3) -- line: 15
			local v9 = p2 or {}
			local v10 = v9.count or 0
			local v11 = v9.requestsById or {}
			local data = p3.responseBody.data
			local nextPageCursor = p3.responseBody.nextPageCursor

			if nextPageCursor == v9.lastCursor and nextPageCursor ~= nil then
				return v9
			end

			for i, v in ipairs(data) do
				local v16 = v10 + i

				if not v11[tostring(v.id)] then
					v11[tostring(v.id)] = v16
				end
			end

			return {
				count = v10 + #data,
				lastCursor = nextPageCursor,
				requestsById = v11
			}
		end
	})
end
