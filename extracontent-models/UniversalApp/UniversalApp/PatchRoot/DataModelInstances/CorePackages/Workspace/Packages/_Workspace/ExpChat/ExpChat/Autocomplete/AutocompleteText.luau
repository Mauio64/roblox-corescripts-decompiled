local Autocomplete = script:FindFirstAncestor("Autocomplete")
local Trie = require(Autocomplete.Trie.Trie)
local t1 = {}

t1.__index = t1

function t1.new(p1: ((...any) -> ...any)) -- line: 11
	-- upvalues: t1 (copy), Trie (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.trie = Trie.new()
	t2.trie = p1(t2)

	return t2
end
function t1.getResults(t3: {[any]: any}, s1: string, p2: ((...any) -> ...any)?) -- line: 22
	local v9 = t3.trie:autocomplete(s1)

	if p2 then
		return p2(v9)
	end

	return v9
end

return t1
