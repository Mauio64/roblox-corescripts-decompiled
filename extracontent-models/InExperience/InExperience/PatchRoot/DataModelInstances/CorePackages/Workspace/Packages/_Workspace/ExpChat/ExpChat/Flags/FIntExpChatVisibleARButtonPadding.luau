local ExpChat = script:FindFirstAncestor("ExpChat")
local FFlagExpChatScrollbarInset = require(ExpChat.Flags.FFlagExpChatScrollbarInset)

local defineFastInt = game:DefineFastInt("ExpChatVisibleARButtonPadding", 42)

local defineFastInt2 = game:DefineFastInt("ExpChatVisibleARButtonPaddingInset", 34)

if FFlagExpChatScrollbarInset then
	return defineFastInt2
end

return defineFastInt
