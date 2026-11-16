local parent = script:FindFirstAncestor("AppChat").Parent

local Rodux = require(parent.Rodux)
require(parent.AppChatNetworking)

return Rodux.makeActionCreator(script.Name, function(modalSequence)
	return { modalSequence = modalSequence }
end)
