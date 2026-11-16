local parent = script:FindFirstAncestor("AppChat").Parent

local Rodux = require(parent.Rodux)
require(parent.AppChatNetworking)

return Rodux.makeActionCreator(script.Name, function(conversationId: string, moderationType)
	return { conversationId = conversationId, moderationType = moderationType }
end)
