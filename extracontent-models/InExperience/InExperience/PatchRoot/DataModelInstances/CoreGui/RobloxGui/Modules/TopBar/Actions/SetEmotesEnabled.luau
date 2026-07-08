local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local FFlagTopBarDeprecateMoreMenuRodux = require(ParentParent.Flags.FFlagTopBarDeprecateMoreMenuRodux)
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

if FFlagTopBarDeprecateMoreMenuRodux then
	return nil
end

return (makeActionCreator(script.Name, function(p1) -- line: 11
	return {
		enabled = p1
	}
end))
