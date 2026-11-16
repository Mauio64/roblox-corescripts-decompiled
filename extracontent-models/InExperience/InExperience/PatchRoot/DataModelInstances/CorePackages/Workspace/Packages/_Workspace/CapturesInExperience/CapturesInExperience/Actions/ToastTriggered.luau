local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

require(parent.Enums.CapturesToastType)
require(parent.Types)

return Rodux.makeActionCreator(script.Name, function(toastType, toastConfig)
	return { toastType = toastType, toastConfig = toastConfig }
end)
