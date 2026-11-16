local parent = script:FindFirstAncestor("ExpChat").Parent
local Autocomplete = script:FindFirstAncestor("Autocomplete")
local llama = require(parent.llama)
local list = llama.List

local TrieNode = require(Autocomplete.Trie.TrieNode)

local Trie = {}
Trie.__index = Trie

function Trie.new()
	local v = {}
	setmetatable(v, Trie)
	v.root = TrieNode.new("")
	return v
end

function Trie.insert(p, value: string)
	local v = p.root

	for i = 1, #value do
		local v2 = string.sub(value, i, i)

		if not v.children[v2] then
			v.children[v2] = TrieNode.new(v2)
		end

		v = v.children[v2]
	end

	v.isEndOfWord = true
end

function Trie:autocomplete(value: string)
	local v = self.root
	local v2 = {}

	for i = 1, #value do
		local v3 = string.sub(value, i, i)

		if not v.children[v3] then
			return v2
		end

		v = v.children[v3]
	end

	return (self:helper(v, v2, (string.sub(value, 1, #value - 1))))
end

function Trie:helper(data, p, p2: string)
	if data.isEndOfWord then
		p = list.push(p, p2 .. data.data)
	end

	for _, child in pairs(data.children) do
		p = self:helper(child, p, p2 .. data.data)
	end

	return p
end

return Trie
