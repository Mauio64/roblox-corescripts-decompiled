local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)

if CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas then
	return nil
end

return (makeActionCreator(script.Name, function(id, position, size)
	return { id = id, position = position, size = size }
end))
