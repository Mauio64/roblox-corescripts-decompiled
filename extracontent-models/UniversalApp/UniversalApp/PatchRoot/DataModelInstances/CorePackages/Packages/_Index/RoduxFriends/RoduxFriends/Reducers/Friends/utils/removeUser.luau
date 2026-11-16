local parent = script:FindFirstAncestor("RoduxFriends").Parent
local llama = require(parent.llama)

return function(options, p)
	return llama.List.removeValue(options or {}, p)
end
