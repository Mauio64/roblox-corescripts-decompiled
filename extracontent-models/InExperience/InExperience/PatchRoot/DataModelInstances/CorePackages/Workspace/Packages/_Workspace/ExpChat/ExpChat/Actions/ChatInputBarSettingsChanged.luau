local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(property: string, p)
	return { property = property, value = p }
end)
