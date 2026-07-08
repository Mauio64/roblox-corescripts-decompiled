local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local FFlagTopBarDeprecateDisplayOptionsRodux = require(ParentParent.Flags.FFlagTopBarDeprecateDisplayOptionsRodux)
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

if FFlagTopBarDeprecateDisplayOptionsRodux then
	return nil
end

return (makeActionCreator(script.Name, function(p1) -- line: 12
	return {
		enabled = p1
	}
end))
