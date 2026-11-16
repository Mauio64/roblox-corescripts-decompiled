local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(childName: string, property: string, p)
	return { childName = childName, property = property, value = p }
end)
