local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local t = dependencies.t
local dictionary = dependencies.llama.Dictionary

local friendsPerLoadGroup = require(script.Parent.friendsPerLoadGroup)

local interface = t.interface({ visibleRows = t.number, itemSize = t.number, filter = t.string })

local interface2 = t.interface({ filterFriendCounts = t.table })

return function(width)
	return function(p, p2)
		assert(interface(p2))
		assert(interface2(p))

		local v = friendsPerLoadGroup({ width = width }, p2)

		return {
			width = width,
			filterFriendCounts = dictionary.join(p.filterFriendCounts, dictionary.map(p.filterFriendCounts, function(p3)
				return (math.max(v, p3))
			end))
		}
	end
end
