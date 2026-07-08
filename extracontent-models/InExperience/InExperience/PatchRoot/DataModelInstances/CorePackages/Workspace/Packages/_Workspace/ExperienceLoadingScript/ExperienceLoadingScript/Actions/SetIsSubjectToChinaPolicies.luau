local Parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent
local Rodux = require(Parent.Rodux)
local ArgCheck = require(Parent.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 7
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "boolean", "SetIsSubjectToChinaPolicies action expects isSubjectToChinaPolicies to be a boolean")

	return {
		isSubjectToChinaPolicies = p1
	}
end)
