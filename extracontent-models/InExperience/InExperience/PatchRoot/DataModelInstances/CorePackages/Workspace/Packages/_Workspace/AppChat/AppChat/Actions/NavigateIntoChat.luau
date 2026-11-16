local parent = script:FindFirstAncestor("AppChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(p)
	return { screen = p.screen, params = p.params }
end)
