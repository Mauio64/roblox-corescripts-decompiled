local parent = script:FindFirstAncestor("ExpChat").Parent
local llama = require(parent.llama)
local list = llama.List
local EmojiList = require(parent.EmojiList)

return function(p)
	return list.sort(p, function(p2: string, p3: string): boolean
		if EmojiList[p2].popularity == EmojiList[p3].popularity then
			return p2 < p3
		end

		return EmojiList[p2].popularity < EmojiList[p3].popularity
	end)
end
