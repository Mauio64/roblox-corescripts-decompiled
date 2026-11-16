local parent = script:FindFirstAncestor("SquadsCore").Parent

local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(arguments)
	return { arguments = arguments }
end)
