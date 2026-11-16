local parent = script:FindFirstAncestor("AppChat").Parent

local Rodux = require(parent.Rodux)
require(parent.AppChatNetworking)

return Rodux.makeActionCreator(script.Name, function(modalSequence, p: string?)
	return { key = p, modalSequence = modalSequence }
end)
