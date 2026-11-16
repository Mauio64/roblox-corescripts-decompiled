local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent
local FFlagTopBarDeprecateDisplayOptionsRodux = require(parent.Flags.FFlagTopBarDeprecateDisplayOptionsRodux)

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

if FFlagTopBarDeprecateDisplayOptionsRodux then
	return nil
end

return (makeActionCreator(script.Name, function(isSmallTouchDevice)
	return { isSmallTouchDevice = isSmallTouchDevice }
end))
