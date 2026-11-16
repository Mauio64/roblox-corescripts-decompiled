local ExpChat = script:FindFirstAncestor("ExpChat")
local FFlagExpChatScrollbarInset = require(ExpChat.Flags.FFlagExpChatScrollbarInset)

local defineFastInt = game:DefineFastInt("ExpChatDefaultARButtonPadding", 9)

local defineFastInt2 = game:DefineFastInt("ExpChatDefaultARButtonPaddingInset", 1)

if FFlagExpChatScrollbarInset then
	return defineFastInt2
end

return defineFastInt
