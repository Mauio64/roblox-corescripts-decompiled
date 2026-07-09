local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 10
	-- upvalues: Url (copy)
	assert(typeof(p2) == "string", "universe has to be a string")

	return p1(string.format("%sv2/games/%s/media", Url.GAME_URL, p2), "GET")
end
