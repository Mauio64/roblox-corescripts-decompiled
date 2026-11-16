local Autocomplete = script:FindFirstAncestor("Autocomplete")
local Trie = require(Autocomplete.Trie.Trie)

local AutocompleteText = {}
AutocompleteText.__index = AutocompleteText

function AutocompleteText.new(callback)
	local v = {}
	setmetatable(v, AutocompleteText)

	v.trie = Trie.new()
	v.trie = callback(v)

	return v
end

function AutocompleteText.getResults(p, p2: string, callback)
	local autocomplete = p.trie:autocomplete(p2)

	if callback then
		return callback(autocomplete)
	end

	return autocomplete
end

return AutocompleteText
