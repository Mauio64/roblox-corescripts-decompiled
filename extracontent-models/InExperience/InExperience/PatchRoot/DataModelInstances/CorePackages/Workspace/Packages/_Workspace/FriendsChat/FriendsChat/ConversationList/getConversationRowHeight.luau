local function getConversationRowHeight(p: number, p2: number, flag: boolean)
	return p + (not flag and 0 or p2 * 2)
end

return getConversationRowHeight
