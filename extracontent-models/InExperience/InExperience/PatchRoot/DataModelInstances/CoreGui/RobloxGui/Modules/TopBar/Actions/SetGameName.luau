local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local FFlagTopBarDeprecateGameInfoRodux = require(ParentParent.Flags.FFlagTopBarDeprecateGameInfoRodux)
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

if FFlagTopBarDeprecateGameInfoRodux then
	return nil
end

return (makeActionCreator(script.Name, function(p1) -- line: 11
	return {
		gameName = p1
	}
end))
