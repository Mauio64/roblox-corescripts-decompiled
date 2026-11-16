local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local TextChatService = game:GetService("TextChatService")

local Constants = require(ChatLineReporting.Common.Constants)

local function findTextChannel(system: string)
	local textChannel = TextChatService:FindFirstChild(system, true)

	while not textChannel do
		wait()
		textChannel = TextChatService:FindFirstChild(system, true)
	end

	return textChannel
end

function sendSystemMessage(p: string)
	if p then
		findTextChannel(Constants.ChannelTypes.System):DisplaySystemMessage(p)
	end
end

return sendSystemMessage
