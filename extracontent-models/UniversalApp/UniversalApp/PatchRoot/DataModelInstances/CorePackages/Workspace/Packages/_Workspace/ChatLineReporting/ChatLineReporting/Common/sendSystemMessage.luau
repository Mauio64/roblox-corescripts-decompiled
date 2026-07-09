local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local TextChatService = game:GetService("TextChatService")
local Constants = require(ChatLineReporting.Common.Constants)

local function findTextChannel(s1: string) -- line: 8
	-- upvalues: TextChatService (copy)
	local s1_2 = TextChatService:FindFirstChild(s1, true)

	while not s1_2 do
		wait()
		s1_2 = TextChatService:FindFirstChild(s1, true)
	end

	return s1_2
end

function sendSystemMessage(s2: string) -- line: 17
	-- upvalues: findTextChannel (copy), Constants (copy)
	if s2 then
		findTextChannel(Constants.ChannelTypes.System):DisplaySystemMessage(s2)
	end
end

return sendSystemMessage
