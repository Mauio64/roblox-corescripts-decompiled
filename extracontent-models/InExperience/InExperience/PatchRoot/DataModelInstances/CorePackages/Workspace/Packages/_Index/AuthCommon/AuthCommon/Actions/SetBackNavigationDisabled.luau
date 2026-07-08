local Parent = script:FindFirstAncestor("AuthCommon").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator
local ArgCheck = require(Parent.ArgCheck)

return makeActionCreator(script.Name, function(p1) -- line: 7
	-- upvalues: ArgCheck (copy)
	return {
		disabled = ArgCheck.isType(p1, "boolean", "disabled")
	}
end)
