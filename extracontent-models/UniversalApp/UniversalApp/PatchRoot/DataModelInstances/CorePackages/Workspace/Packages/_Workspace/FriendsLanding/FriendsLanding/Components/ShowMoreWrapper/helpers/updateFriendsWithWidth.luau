local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local t = dependencies.t
local Dictionary = dependencies.llama.Dictionary
local friendsPerLoadGroup = require(script.Parent.friendsPerLoadGroup)
local v6 = t.interface({
	visibleRows = t.number,
	itemSize = t.number,
	filter = t.string
})
local v7 = t.interface({
	filterFriendCounts = t.table
})

return function(p1) -- line: 20
	-- upvalues: v6 (copy), v7 (copy), friendsPerLoadGroup (copy), Dictionary (copy)
	return function(p2, p3) -- line: 21
		-- upvalues: v6 (copy), v7 (copy), friendsPerLoadGroup (copy), p1 (copy), Dictionary (copy)
		assert(v6(p3))
		assert(v7(p2))

		local v11 = friendsPerLoadGroup({
			width = p1
		}, p3)

		return {
			width = p1,
			filterFriendCounts = Dictionary.join(p2.filterFriendCounts, Dictionary.map(p2.filterFriendCounts, function(p4) -- line: 31
				-- upvalues: v11 (copy)
				return (math.max(v11, p4))
			end))
		}
	end
end
