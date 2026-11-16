local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

require(parent.Types)

return Rodux.makeActionCreator(script.Name, function(captures, selectedCapture)
	return { captures = captures, selectedCapture = selectedCapture }
end)
