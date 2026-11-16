local parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent

local Rodux = require(parent.Rodux)
local ArgCheck = require(parent.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(isSubjectToChinaPolicies)
	ArgCheck.isType(
		isSubjectToChinaPolicies,
		"boolean",
		"SetIsSubjectToChinaPolicies action expects isSubjectToChinaPolicies to be a boolean"
	)

	return { isSubjectToChinaPolicies = isSubjectToChinaPolicies }
end)
