local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent
local FFlagTopBarDeprecateCoreGuiRodux = require(parent.Flags.FFlagTopBarDeprecateCoreGuiRodux)

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

if FFlagTopBarDeprecateCoreGuiRodux then
	return nil
end

return (makeActionCreator(script.Name, function(coreGuiType, enabled)
	return { coreGuiType = coreGuiType, enabled = enabled }
end))
