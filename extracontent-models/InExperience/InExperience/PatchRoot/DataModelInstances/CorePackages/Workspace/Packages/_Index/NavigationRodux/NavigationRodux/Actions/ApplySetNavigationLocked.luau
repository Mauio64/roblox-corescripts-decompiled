local parent = script:FindFirstAncestor("NavigationRodux").Parent

local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local ArgCheck = require(parent.ArgCheck)

return makeActionCreator(script.Name, function(p)
	return {
		locked = ArgCheck.isType(p, "boolean", "locked")
	}
end)
