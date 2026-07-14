local ExpChat = script:FindFirstAncestor("ExpChat")
local FFlagExpChatScrollbarInset = require(ExpChat.Flags.FFlagExpChatScrollbarInset)
local v3 = game:DefineFastInt("ExpChatDefaultARButtonPadding", 9)
local v4 = game:DefineFastInt("ExpChatDefaultARButtonPaddingInset", 1)

if FFlagExpChatScrollbarInset then
	return v4
end

return v3
