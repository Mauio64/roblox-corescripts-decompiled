local Parent = script:FindFirstAncestor("AppChat").Parent
local Rodux = require(Parent.Rodux)

require(Parent.AppChatNetworking)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 14
	return {
		modalSequence = p1
	}
end)
