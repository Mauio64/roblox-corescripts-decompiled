local Parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent
local Rodux = require(Parent.Rodux)
local ArgCheck = require(Parent.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 7
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "SetGameProductInfo action expects productInfo to be a table")

	return {
		productInfo = p1
	}
end)
