local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent
local FFlagTopBarDeprecateGameInfoRodux = require(parent.Flags.FFlagTopBarDeprecateGameInfoRodux)

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

if FFlagTopBarDeprecateGameInfoRodux then
	return nil
end

return (makeActionCreator(script.Name, function(gameName)
	return { gameName = gameName }
end))
