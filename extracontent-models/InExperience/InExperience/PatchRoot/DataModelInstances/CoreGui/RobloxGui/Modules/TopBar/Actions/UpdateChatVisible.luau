local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent
local FFlagTopBarDeprecateChatRodux = require(parent.Flags.FFlagTopBarDeprecateChatRodux)

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

if FFlagTopBarDeprecateChatRodux then
	return nil
end

return (makeActionCreator(script.Name, function(visible)
	return { visible = visible }
end))
