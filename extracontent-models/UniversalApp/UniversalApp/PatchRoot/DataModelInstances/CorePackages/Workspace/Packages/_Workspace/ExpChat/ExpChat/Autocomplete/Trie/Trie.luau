local Parent = script:FindFirstAncestor("ExpChat").Parent
local Autocomplete = script:FindFirstAncestor("Autocomplete")
local List = require(Parent.llama).List
local TrieNode = require(Autocomplete.Trie.TrieNode)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 11
	-- upvalues: t1 (copy), TrieNode (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.root = TrieNode.new("")

	return t2
end
function t1.insert(t3: {[any]: any}, s1: string) -- line: 18
	-- upvalues: TrieNode (copy)
	local root = t3.root

	for i = 1, #s1 do
		local v11 = string.sub(s1, i, i)

		if not root.children[v11] then
			root.children[v11] = TrieNode.new(v11)
		end

		root = root.children[v11]
	end

	root.isEndOfWord = true
end
function t1.autocomplete(t4: {[any]: any}, s2: string) -- line: 30
	local t5 = {}
	local root = t4.root

	for i = 1, #s2 do
		local v17 = string.sub(s2, i, i)

		if not root.children[v17] then
			return t5
		end

		root = root.children[v17]
	end

	return (t4:helper(root, t5, (string.sub(s2, 1, #s2 - 1))))
end
function t1.helper(t6: {[any]: any}, p1, t7: {[any]: any}, s3: string) -- line: 45
	-- upvalues: List (copy)
	if p1.isEndOfWord then
		t7 = List.push(t7, s3 .. p1.data)
	end

	for _, v in pairs(p1.children) do
		t7 = t6:helper(v, t7, s3 .. p1.data)
	end

	return t7
end

return t1
