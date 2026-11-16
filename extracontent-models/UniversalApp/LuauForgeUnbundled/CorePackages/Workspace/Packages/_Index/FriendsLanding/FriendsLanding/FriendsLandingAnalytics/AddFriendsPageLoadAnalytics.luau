local llama = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies").llama

return function(p2)
	local values = {}
	local v5 = {}
	local senderIds = {}
	local v6 = {}

	for k, v7 in pairs(p2.responseBody.data) do
		table.insert(values, table.concat(llama.List.map(v7.mutualFriendsList, function(p3)
			return p3
		end), ","))

		table.insert(v5, not v7.friendRequest.sourceUniverseId and 0 or v7.friendRequest.sourceUniverseId)

		table.insert(senderIds, v7.friendRequest.senderId)
		table.insert(v6, k)
	end

	return {
		page = "friendRequests",
		requestingUserId = table.concat(senderIds, ","),
		gamesContext = table.concat(v5, ","),
		absPosition = table.concat(v6, ","),
		mutualFriendsContext = table.concat(values, ";")
	}
end
