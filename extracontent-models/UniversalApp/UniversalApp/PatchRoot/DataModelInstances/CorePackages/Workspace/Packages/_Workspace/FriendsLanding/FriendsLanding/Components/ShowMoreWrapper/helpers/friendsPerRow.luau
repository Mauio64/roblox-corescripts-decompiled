local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local t = require(FriendsLanding.dependencies).t
local v3 = t.interface({
	width = t.number,
	itemSize = t.number,
	minimumItemsPerRow = t.optional(t.number)
})

return function(p1) -- line: 13
	-- upvalues: v3 (copy)
	assert(v3(p1))

	return (math.max(math.floor(p1.width / p1.itemSize), p1.minimumItemsPerRow or 2))
end
