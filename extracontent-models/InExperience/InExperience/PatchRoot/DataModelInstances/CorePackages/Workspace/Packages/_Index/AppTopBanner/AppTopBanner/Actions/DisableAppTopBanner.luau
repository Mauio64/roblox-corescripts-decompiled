local parent = script:FindFirstAncestor("AppTopBanner").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(isDisabled)
	return { isDisabled = isDisabled }
end)
