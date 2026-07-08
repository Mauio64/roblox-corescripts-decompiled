local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

if require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeKeepOutAreas then
	return nil
end

return (makeActionCreator(script.Name, function(p1) -- line: 11
	return {
		id = p1
	}
end))
