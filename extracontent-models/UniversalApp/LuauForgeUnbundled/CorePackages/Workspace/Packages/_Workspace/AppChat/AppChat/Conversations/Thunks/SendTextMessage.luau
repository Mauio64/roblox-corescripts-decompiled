local SendMessageUsingPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendMessageUsingPolicy")
local SendChatTextMessagePolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendPolicies/SendChatTextMessagePolicy")

return function(p2, p3, p4, p5)
	return SendMessageUsingPolicy((SendChatTextMessagePolicy:new(p2, p3, p4, p5)))
end
