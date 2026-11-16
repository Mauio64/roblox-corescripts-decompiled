local class = {}
class.__index = class

function class.new(p: string)
	local self = setmetatable({}, class)
	self.children = {}
	self.isEndOfWord = false
	self.data = p
	return self
end

local Trie = {}
Trie.__index = Trie

function Trie.new()
	local self = setmetatable({}, Trie)
	self.root = class.new("")
	return self
end

function Trie.insert(p, value: string)
	local v = p.root

	for i = 1, #value do
		local v2 = string.sub(value, i, i)

		if not v.children[v2] then
			v.children[v2] = class.new(v2)
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

	self:_collect(v, v2, (string.sub(value, 1, #value - 1)))
	return v2
end

function Trie:_collect(data, list, p: string)
	if data.isEndOfWord then
		table.insert(list, p .. data.data)
	end

	for _, child in pairs(data.children) do
		self:_collect(child, list, p .. data.data)
	end
end

return Trie
