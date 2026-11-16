local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local parent = FriendsRodux.Parent
local Rodux = require(parent.Rodux)

require(FriendsRodux.roduxFriendsTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddFriendsRefreshRequestOrder = SharedFlags.FFlagAddFriendsRefreshRequestOrder

local v = {}

local function parkTrailingScores(options, data)
	local idSet = {}

	for _, item in ipairs(data) do
		idSet[tostring(item.id)] = true
	end

	local v2 = {}

	for k, score in pairs(options and options.requestsById or {}) do
		if not idSet[k] then
			table.insert(v2, { userId = k, score = score })
		end
	end

	table.sort(v2, function(a, b): boolean
		return a.score < b.score
	end)

	local result = {}

	for i, v3 in ipairs(v2) do
		result[v3.userId] = #data + i
	end

	return result, #v2
end

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(options, p2)
			local v2

			if FFlagAddFriendsRefreshRequestOrder and p2.queryArgs and p2.queryArgs.cursor == nil then
				local requestsById
				requestsById, v2 = parkTrailingScores(options, p2.responseBody.data)
				options = { requestsById = requestsById }
			else
				v2 = 0
			end

			local v3 = options or {}
			local count = v3.count or 0
			local requestsById = v3.requestsById or {}

			local data = p2.responseBody.data
			local nextPageCursor = p2.responseBody.nextPageCursor

			if nextPageCursor == v3.lastCursor and nextPageCursor ~= nil then
				return v3
			end

			for i, v4 in ipairs(data) do
				local v5 = count + i

				if requestsById[tostring(v4.id)] then
					continue
				end

				if FFlagAddFriendsRefreshRequestOrder then
					requestsById[tostring(v4.id)] = v5
				elseif v4.isUnseen then
					local sentAt = v4.friendRequest.sentAt

					local v6 = string.gsub(sentAt, "%.%d+Z$", "Z")
					local v7 = tonumber((string.gsub(v6, "%D", ""))) or 0

					requestsById[tostring(v4.id)] = -v7
				else
					requestsById[tostring(v4.id)] = v5
				end
			end

			local count2 = count + #data

			if FFlagAddFriendsRefreshRequestOrder then
				count2 += v2
			end

			return { count = count2, lastCursor = nextPageCursor, requestsById = requestsById }
		end
	})
end
