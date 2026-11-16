local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local llama = dependencies.llama

return function(p)
	local values = {}
	local v = {}
	local senderIds = {}
	local v2 = {}

	for k, v3 in pairs(p.responseBody.data) do
		table.insert(values, table.concat(llama.List.map(v3.mutualFriendsList, function(p2)
			return p2
		end), ","))

		table.insert(v, not v3.friendRequest.sourceUniverseId and 0 or v3.friendRequest.sourceUniverseId)

		table.insert(senderIds, v3.friendRequest.senderId)
		table.insert(v2, k)
	end

	return {
		page = "friendRequests",
		requestingUserId = table.concat(senderIds, ","),
		gamesContext = table.concat(v, ","),
		absPosition = table.concat(v2, ","),
		mutualFriendsContext = table.concat(values, ";")
	}
end
