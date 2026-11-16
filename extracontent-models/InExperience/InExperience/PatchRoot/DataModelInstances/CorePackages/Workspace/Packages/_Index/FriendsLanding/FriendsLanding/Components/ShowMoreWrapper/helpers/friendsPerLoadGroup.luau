local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local llama = dependencies.llama
local t = dependencies.t
local friendsPerRow = require(script.Parent.friendsPerRow)

local interface = t.interface({ width = t.number })

local interface2 = t.interface({
	visibleRows = t.number,
	itemSize = t.number,
	minimumItemsPerRow = t.optional(t.number)
})

return function(p, p2)
	assert(interface(p))
	assert(interface2(p2))
	return p2.visibleRows * friendsPerRow(llama.Dictionary.join({ width = p.width }, p2))
end
