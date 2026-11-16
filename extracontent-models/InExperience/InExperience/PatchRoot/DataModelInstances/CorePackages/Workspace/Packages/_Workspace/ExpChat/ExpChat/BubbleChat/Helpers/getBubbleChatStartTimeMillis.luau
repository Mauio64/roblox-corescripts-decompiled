local isBorderlessBubbleChatMessage = require(script.Parent.isBorderlessBubbleChatMessage)
require(script.Parent.getBubbleChatDisplayText)

local function getBubbleChatStartTimeMillis(p)
	if isBorderlessBubbleChatMessage(p) and p.bubbleChatReceivedAtMillis then
		return p.bubbleChatReceivedAtMillis
	end

	return p.timestamp.UnixTimestampMillis
end

return getBubbleChatStartTimeMillis
