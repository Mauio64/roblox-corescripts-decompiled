local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local fFlagAddFriendsRefreshRequestOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/SharedFlags").FFlagAddFriendsRefreshRequestOrder

local v5 = {}

local function parkTrailingScores(options, data)
	local idSet = {}

	for i, item in ipairs(data) do
		idSet[tostring(item.id)] = true
	end

	local v6 = {}

	for k, v7 in pairs(options and options.requestsById or {}) do
		if not idSet[k] then
			table.insert(v6, { userId = k, score = v7 })
		end
	end

	table.sort(v6, function(a, b): boolean
		return a.score < b.score
	end)

	local result = {}

	for i, v7 in ipairs(v6) do
		result[v7.userId] = #data + i
	end

	return result, #v6
end

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(v5, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(options, p3)
			local v8

			if fFlagAddFriendsRefreshRequestOrder and p3.queryArgs and p3.queryArgs.cursor == nil then
				local v9
				v9, v8 = parkTrailingScores(options, p3.responseBody.data)
				options = { requestsById = v9 }
			else
				v8 = 0
			end

			local v9 = options or {}
			local count = v9.count or 0
			local requestsById = v9.requestsById or {}

			local data = p3.responseBody.data
			local nextPageCursor = p3.responseBody.nextPageCursor

			if nextPageCursor == v9.lastCursor and nextPageCursor ~= nil then
				return v9
			end

			for i, v10 in ipairs(data) do
				local v11 = count + i

				if requestsById[tostring(v10.id)] then
					continue
				end

				if fFlagAddFriendsRefreshRequestOrder then
					requestsById[tostring(v10.id)] = v11
				elseif v10.isUnseen then
					local sentAt = v10.friendRequest.sentAt

					local v12 = string.gsub(sentAt, "%.%d+Z$", "Z")
					local v13 = tonumber((string.gsub(v12, "%D", ""))) or 0

					requestsById[tostring(v10.id)] = -v13
				else
					requestsById[tostring(v10.id)] = v11
				end
			end

			local v10 = count + #data

			if fFlagAddFriendsRefreshRequestOrder then
				v10 += v8
			end

			return {
				count = v10,
				lastCursor = nextPageCursor,
				requestsById = requestsById
			}
		end
	})
end
