local ExpChat = script:FindFirstAncestor("ExpChat")
local FFlagExpChatScrollbarInset = require(ExpChat.Flags.FFlagExpChatScrollbarInset)
local v3 = game:DefineFastInt("ExpChatVisibleARButtonPadding", 42)
local v4 = game:DefineFastInt("ExpChatVisibleARButtonPaddingInset", 34)

if FFlagExpChatScrollbarInset then
	return v4
end

return v3
