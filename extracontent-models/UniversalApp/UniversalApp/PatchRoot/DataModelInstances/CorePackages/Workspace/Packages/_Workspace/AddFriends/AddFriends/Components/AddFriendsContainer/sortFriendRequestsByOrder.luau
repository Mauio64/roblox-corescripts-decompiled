local Parent = script:FindFirstAncestor("AddFriends").Parent
local llama = require(Parent.llama)
local t = require(Parent.t)

return function(t1: {[any]: any}) -- line: 15
	-- upvalues: t (copy), llama (copy)
	assert(t.table(t1))

	return llama.List.sort(t1, function(p1, p2) -- line: 18
		return (p1.order or 9999999) < (p2.order or 9999999)
	end)
end
