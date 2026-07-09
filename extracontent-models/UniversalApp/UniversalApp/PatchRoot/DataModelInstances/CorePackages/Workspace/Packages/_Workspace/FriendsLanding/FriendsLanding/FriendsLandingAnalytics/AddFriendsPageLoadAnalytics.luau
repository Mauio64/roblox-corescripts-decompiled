local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local llama = require(FriendsLanding.dependencies).llama

return function(p1) -- line: 5
	-- upvalues: llama (copy)
	local t1 = {}
	local t2 = {}
	local t3 = {}
	local t4 = {}

	for k, v in pairs(p1.responseBody.data) do
		table.insert(t1, table.concat(llama.List.map(v.mutualFriendsList, function(p2) -- line: 14
			return p2
		end), ","))
		table.insert(t2, not v.friendRequest.sourceUniverseId and 0 or v.friendRequest.sourceUniverseId)
		table.insert(t3, v.friendRequest.senderId)
		table.insert(t4, k)
	end

	return {
		page = "friendRequests",
		requestingUserId = table.concat(t3, ","),
		gamesContext = table.concat(t2, ","),
		absPosition = table.concat(t4, ","),
		mutualFriendsContext = table.concat(t1, ";")
	}
end
