local Parent = script:FindFirstAncestor("AppChat").Parent
local Rodux = require(Parent.Rodux)

require(Parent.AppChatNetworking)

return Rodux.makeActionCreator(script.Name, function(s1: string, p1) -- line: 14
	return {
		conversationId = s1,
		moderationType = p1
	}
end)
