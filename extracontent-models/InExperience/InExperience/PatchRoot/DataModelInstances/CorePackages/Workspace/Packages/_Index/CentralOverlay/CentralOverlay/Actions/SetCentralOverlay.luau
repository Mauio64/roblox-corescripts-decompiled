local parent = script:FindFirstAncestor("CentralOverlay").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(overlayType, arguments, configs)
	return { overlayType = overlayType, arguments = arguments, configs = configs }
end)
