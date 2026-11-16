local parent = script.Parent.Parent.Parent

local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(universeId: number, isEligible: boolean)
	return { universeId = universeId, isEligible = isEligible }
end)
