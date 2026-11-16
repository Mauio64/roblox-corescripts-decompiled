local parent = script:FindFirstAncestor("RoduxFriends").Parent
local Rodux = require(parent.Rodux)

local v = {}

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(options, p2)
			local v2 = options or {}
			local count = v2.count or 0
			local requestsById = v2.requestsById or {}

			local data = p2.responseBody.data
			local nextPageCursor = p2.responseBody.nextPageCursor

			if nextPageCursor == v2.lastCursor and nextPageCursor ~= nil then
				return v2
			end

			for i, v3 in ipairs(data) do
				local v4 = count + i

				if not requestsById[tostring(v3.id)] then
					requestsById[tostring(v3.id)] = v4
				end
			end

			return {
				count = count + #data,
				lastCursor = nextPageCursor,
				requestsById = requestsById
			}
		end
	})
end
