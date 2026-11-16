local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local llama = dependencies.llama
local t = dependencies.t

return function(p, p2)
	assert(t.table(p2))
	assert(t.number(p))

	return llama.List.filter(p2, function(_, p3): boolean
		return p3 <= p
	end)
end
