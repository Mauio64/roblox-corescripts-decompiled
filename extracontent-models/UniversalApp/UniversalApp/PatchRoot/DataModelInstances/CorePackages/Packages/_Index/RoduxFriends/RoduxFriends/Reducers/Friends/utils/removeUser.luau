local Parent = script:FindFirstAncestor("RoduxFriends").Parent
local llama = require(Parent.llama)

return function(p1, p2) -- line: 5
	-- upvalues: llama (copy)
	return llama.List.removeValue(p1 or {}, p2)
end
