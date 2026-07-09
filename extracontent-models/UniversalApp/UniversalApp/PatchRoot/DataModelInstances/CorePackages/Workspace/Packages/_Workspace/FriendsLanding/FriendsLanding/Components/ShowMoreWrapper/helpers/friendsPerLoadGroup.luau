local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local llama = dependencies.llama
local t = dependencies.t
local friendsPerRow = require(script.Parent.friendsPerRow)
local v6 = t.interface({
	width = t.number
})
local v7 = t.interface({
	visibleRows = t.number,
	itemSize = t.number,
	minimumItemsPerRow = t.optional(t.number)
})

return function(p1, p2) -- line: 17
	-- upvalues: v6 (copy), v7 (copy), friendsPerRow (copy), llama (copy)
	assert(v6(p1))
	assert(v7(p2))

	return p2.visibleRows * friendsPerRow(llama.Dictionary.join({
		width = p1.width
	}, p2))
end
