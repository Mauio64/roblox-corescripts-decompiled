local Parent = script:FindFirstAncestor("AppChat").Parent
local Rodux = require(Parent.Rodux)

require(Parent.AppChatNetworking)

return Rodux.makeActionCreator(script.Name, function(s1: string, p1) -- line: 15
	return {
		conversationId = s1,
		modalVariant = p1
	}
end)
