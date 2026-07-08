local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local llama = dependencies.llama
local t = dependencies.t

return function(p1, p2) -- line: 6
	-- upvalues: t (copy), llama (copy)
	assert(t.table(p2))
	assert(t.number(p1))

	return llama.List.filter(p2, function(_, p4) -- line: 10
		-- upvalues: p1 (copy)
		return p4 <= p1
	end)
end
