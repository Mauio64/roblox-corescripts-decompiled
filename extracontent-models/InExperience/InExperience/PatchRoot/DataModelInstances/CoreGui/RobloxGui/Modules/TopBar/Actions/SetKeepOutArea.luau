local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

if require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeKeepOutAreas then
	return nil
end

return (makeActionCreator(script.Name, function(p1, p2, p3) -- line: 11
	return {
		id = p1,
		position = p2,
		size = p3
	}
end))
