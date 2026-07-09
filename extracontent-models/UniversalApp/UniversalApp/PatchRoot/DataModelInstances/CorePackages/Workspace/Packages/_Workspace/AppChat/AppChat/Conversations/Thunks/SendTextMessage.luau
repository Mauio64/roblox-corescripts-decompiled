local SendMessageUsingPolicy = require(script.Parent.SendMessageUsingPolicy)
local SendChatTextMessagePolicy = require(script.Parent.SendPolicies.SendChatTextMessagePolicy)

return function(p1, p2, p3, p4) -- line: 4
	-- upvalues: SendChatTextMessagePolicy (copy), SendMessageUsingPolicy (copy)
	local v7 = SendChatTextMessagePolicy:new(p1, p2, p3, p4)

	return SendMessageUsingPolicy(v7)
end
