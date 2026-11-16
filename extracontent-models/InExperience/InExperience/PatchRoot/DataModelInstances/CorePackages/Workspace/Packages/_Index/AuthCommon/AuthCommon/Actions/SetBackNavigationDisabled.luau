local parent = script:FindFirstAncestor("AuthCommon").Parent
local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local ArgCheck = require(parent.ArgCheck)

return makeActionCreator(script.Name, function(p)
	return {
		disabled = ArgCheck.isType(p, "boolean", "disabled")
	}
end)
