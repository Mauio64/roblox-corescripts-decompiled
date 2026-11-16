local parent = script:FindFirstAncestor("AppTabBarRodux").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(isVisible)
	return { isVisible = isVisible }
end)
