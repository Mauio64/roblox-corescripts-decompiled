local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local t = dependencies.t

local interface = t.interface({
	width = t.number,
	itemSize = t.number,
	minimumItemsPerRow = t.optional(t.number)
})

return function(data)
	assert(interface(data))

	return (math.max(math.floor(data.width / data.itemSize), data.minimumItemsPerRow or 2))
end
