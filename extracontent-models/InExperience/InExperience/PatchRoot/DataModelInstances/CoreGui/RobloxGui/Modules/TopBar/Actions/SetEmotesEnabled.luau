local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent
local FFlagTopBarDeprecateMoreMenuRodux = require(parent.Flags.FFlagTopBarDeprecateMoreMenuRodux)

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

if FFlagTopBarDeprecateMoreMenuRodux then
	return nil
end

return (makeActionCreator(script.Name, function(enabled)
	return { enabled = enabled }
end))
