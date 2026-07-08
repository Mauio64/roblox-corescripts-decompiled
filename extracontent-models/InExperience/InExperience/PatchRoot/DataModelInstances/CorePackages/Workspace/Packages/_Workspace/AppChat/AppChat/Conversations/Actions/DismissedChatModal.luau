local Parent = script:FindFirstAncestor("AppChat").Parent
local Rodux = require(Parent.Rodux)

require(Parent.AppChatNetworking)

return Rodux.makeActionCreator(script.Name, function(p1, s1: string?) -- line: 13
	return {
		key = s1,
		modalSequence = p1
	}
end)
