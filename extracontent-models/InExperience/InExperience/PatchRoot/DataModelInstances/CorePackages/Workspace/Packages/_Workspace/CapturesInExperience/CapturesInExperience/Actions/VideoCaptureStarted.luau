local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

require(parent.Enums.CaptureTriggerType)

return Rodux.makeActionCreator(script.Name, function(triggerType)
	return { triggerType = triggerType }
end)
