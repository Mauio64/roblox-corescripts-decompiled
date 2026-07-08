local Parent = script:FindFirstAncestor("ExpChat").Parent
local List = require(Parent.llama).List
local Dictionary = require(Parent.llama).Dictionary
local EmojiList = require(Parent.EmojiList)
local v5 = Dictionary.keys(EmojiList)

return function(p1) -- line: 9
	-- upvalues: List (copy), v5 (copy)
	List.map(v5, function(p2) -- line: 10
		-- upvalues: p1 (copy)
		p1.trie:insert(p2)
	end)

	return p1.trie
end
