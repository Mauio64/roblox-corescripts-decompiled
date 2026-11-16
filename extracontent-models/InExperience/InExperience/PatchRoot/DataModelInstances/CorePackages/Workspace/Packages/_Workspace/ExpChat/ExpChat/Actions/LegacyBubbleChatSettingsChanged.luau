local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(chatSettings)
	return { chatSettings = chatSettings }
end)
