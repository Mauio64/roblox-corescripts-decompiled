local parent = script:FindFirstAncestor("FormFactor").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(formFactor)
	return { formFactor = formFactor }
end)
