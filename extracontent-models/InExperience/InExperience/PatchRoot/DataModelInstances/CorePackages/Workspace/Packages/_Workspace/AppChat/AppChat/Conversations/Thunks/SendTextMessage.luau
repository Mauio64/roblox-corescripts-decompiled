local SendMessageUsingPolicy = require(script.Parent.SendMessageUsingPolicy)
local SendChatTextMessagePolicy = require(script.Parent.SendPolicies.SendChatTextMessagePolicy)

return function(p, p2, p3, p4)
	return SendMessageUsingPolicy((SendChatTextMessagePolicy:new(p, p2, p3, p4)))
end
