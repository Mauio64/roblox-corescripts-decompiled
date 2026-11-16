local TrieNode = {}
TrieNode.__index = TrieNode

function TrieNode.new(p: string)
	local v = {}
	setmetatable(v, TrieNode)
	v.children = {}
	v.isEndOfWord = false
	v.data = p
	return v
end

return TrieNode
