local parent = script:FindFirstAncestor("RoduxFriends").Parent
local llama = require(parent.llama)

return function(p, p2)
	if not p then
		return { p2 }
	end

	if llama.List.find(p, p2) then
		return p
	end

	return llama.List.join(p, { p2 })
end
