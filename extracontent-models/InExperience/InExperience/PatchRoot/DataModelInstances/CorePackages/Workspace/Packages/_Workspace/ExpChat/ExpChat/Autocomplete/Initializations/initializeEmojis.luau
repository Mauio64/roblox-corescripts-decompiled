local parent = script:FindFirstAncestor("ExpChat").Parent
local llama = require(parent.llama)
local list = llama.List
local llama2 = require(parent.llama)
local dictionary = llama2.Dictionary
local EmojiList = require(parent.EmojiList)

local keys = dictionary.keys(EmojiList)

return function(p)
	list.map(keys, function(p2)
		p.trie:insert(p2)
	end)

	return p.trie
end
