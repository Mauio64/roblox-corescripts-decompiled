local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local t = dependencies.t
local llama = dependencies.llama

local friendsPerLoadGroup = require(script.Parent.friendsPerLoadGroup)

local interface = t.interface({ visibleRows = t.number, itemSize = t.number, filter = t.string })

local interface2 = t.interface({ width = t.number, filterFriendCounts = t.table })

return function(p, p2)
	assert(interface2(p))
	assert(interface(p2))

	local v = friendsPerLoadGroup(p, p2)
	local v2 = p.filterFriendCounts[p2.filter] + v
	return {
		filterFriendCounts = llama.Dictionary.join(p.filterFriendCounts, { [p2.filter] = v2 })
	}
end
