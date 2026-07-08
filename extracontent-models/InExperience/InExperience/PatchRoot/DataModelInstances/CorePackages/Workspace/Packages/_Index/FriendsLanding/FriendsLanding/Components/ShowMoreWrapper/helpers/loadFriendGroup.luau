local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local t = dependencies.t
local llama = dependencies.llama
local friendsPerLoadGroup = require(script.Parent.friendsPerLoadGroup)
local v6 = t.interface({
	visibleRows = t.number,
	itemSize = t.number,
	filter = t.string
})
local v7 = t.interface({
	width = t.number,
	filterFriendCounts = t.table
})

return function(p1, p2) -- line: 19
	-- upvalues: v7 (copy), v6 (copy), friendsPerLoadGroup (copy), llama (copy)
	assert(v7(p1))
	assert(v6(p2))

	local v10 = friendsPerLoadGroup(p1, p2)
	local v11 = p1.filterFriendCounts[p2.filter] + v10

	return {
		filterFriendCounts = llama.Dictionary.join(p1.filterFriendCounts, {
			[p2.filter] = v11
		})
	}
end
