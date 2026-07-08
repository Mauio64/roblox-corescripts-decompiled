local Parent = script:FindFirstAncestor("ExpChat").Parent
local List = require(Parent.llama).List
local EmojiList = require(Parent.EmojiList)

return function(p1) -- line: 6
	-- upvalues: List (copy), EmojiList (copy)
	return List.sort(p1, function(s1: string, s2: string) -- line: 10
		-- upvalues: EmojiList (copy)
		if EmojiList[s1].popularity == EmojiList[s2].popularity then
			return s1 < s2
		end

		return EmojiList[s1].popularity < EmojiList[s2].popularity
	end)
end
