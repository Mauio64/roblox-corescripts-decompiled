local isBorderlessBubbleChatMessage = require(script.Parent.isBorderlessBubbleChatMessage)
require(script.Parent.getBubbleChatDisplayText)

local function getBubbleDurationInMillis(p, p2: number)
	return if isBorderlessBubbleChatMessage(p) then 3400 else p2
end

return getBubbleDurationInMillis
