local Parent = script:FindFirstAncestor("RoduxFriends").Parent
local llama = require(Parent.llama)

return function(p1, p2) -- line: 5
	-- upvalues: llama (copy)
	if not p1 then
		return { p2 }
	end

	if not llama.List.find(p1, p2) then
		return llama.List.join(p1, { p2 })
	end

	return p1
end
