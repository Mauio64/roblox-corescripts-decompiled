local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local FFlagTopBarDeprecateCoreGuiRodux = require(ParentParent.Flags.FFlagTopBarDeprecateCoreGuiRodux)
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

if FFlagTopBarDeprecateCoreGuiRodux then
	return nil
end

return (makeActionCreator(script.Name, function(p1, p2) -- line: 11
	return {
		coreGuiType = p1,
		enabled = p2
	}
end))
