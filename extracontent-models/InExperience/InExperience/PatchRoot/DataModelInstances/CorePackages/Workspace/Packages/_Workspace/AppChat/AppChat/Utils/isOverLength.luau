local AppChat = script:FindFirstAncestor("AppChat")

local countChars = require(AppChat.Utils.countChars)
local countUtf16Units = require(AppChat.Utils.countUtf16Units)

local function isOverLength(list: string, p: number, p2: number): boolean
	return not (#list <= math.min(p, p2)) and (p2 < countUtf16Units(list) or p < countChars(list))
end

return isOverLength
