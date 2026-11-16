local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

require(parent.Types)

return Rodux.makeActionCreator(script.Name, function(selectedCaptures)
	return { selectedCaptures = selectedCaptures }
end)
