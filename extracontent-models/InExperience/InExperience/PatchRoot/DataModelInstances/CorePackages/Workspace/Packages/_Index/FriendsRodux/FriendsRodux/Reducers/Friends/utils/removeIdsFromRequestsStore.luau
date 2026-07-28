local Parent = script:FindFirstAncestor("FriendsRodux").Parent
local llama = require(Parent.llama)

return function(p1, t1: {[any]: any}) -- line: 5
	-- upvalues: llama (copy)
	local t2 = {}

	for _, v in pairs(t1) do
		t2[v] = llama.None
	end

	return llama.Dictionary.join(p1, t2)
end
