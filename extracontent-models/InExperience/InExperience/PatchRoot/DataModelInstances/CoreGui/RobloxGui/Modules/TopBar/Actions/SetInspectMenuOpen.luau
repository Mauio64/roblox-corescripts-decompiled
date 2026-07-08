local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

if require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeMenuOpen then
	return nil
end

return (makeActionCreator(script.Name, function(p1) -- line: 9
	return {
		inspectMenuOpen = p1
	}
end))
