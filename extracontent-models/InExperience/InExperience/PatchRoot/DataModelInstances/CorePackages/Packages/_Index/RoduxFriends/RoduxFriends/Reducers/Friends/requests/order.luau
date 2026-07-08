local Parent = script:FindFirstAncestor("RoduxFriends").Parent
local Rodux = require(Parent.Rodux)
local t1 = {}

return function(p1) -- line: 9
	-- upvalues: Rodux (copy), t1 (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p2, p3) -- line: 13
			local v8 = p2 or {}
			local v9 = v8.count or 0
			local v10 = v8.requestsById or {}
			local data = p3.responseBody.data
			local nextPageCursor = p3.responseBody.nextPageCursor

			if nextPageCursor == v8.lastCursor and nextPageCursor ~= nil then
				return v8
			end

			for i, v in ipairs(data) do
				local v15 = v9 + i

				if not v10[tostring(v.id)] then
					v10[tostring(v.id)] = v15
				end
			end

			return {
				count = v9 + #data,
				lastCursor = nextPageCursor,
				requestsById = v10
			}
		end
	})
end
